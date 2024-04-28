class PortfoliosController < ApplicationController
  before_action :require_trader
  before_action :set_client

  def index
    @portfolios = current_trader.portfolios
    @pagy, @paginated_portfolios = pagy(@portfolios)
    @total_portfolio_value = Portfolio.calculate_total_portfolio_value(@portfolios)
    @cash_balance = current_trader.wallet
    @portfolio_total_value_by_day = Portfolio.cumulative_total_value_by_day
    @quotes = {}
    @ohlc = {}

    @portfolios.each do |portfolio|
      portfolio.stocks.each do |stock|
        @quotes[stock.ticker_symbol] = @client.quote(stock.ticker_symbol)
        @ohlc[stock.ticker_symbol] = @client.ohlc(stock.ticker_symbol)
      end
    end
    
    fetch_realtime_data_for_stocks(@portfolios)
    StockPrice.update_stock_prices_for_today(@client)
    StockPrice.update_stock_prices_for_yesterday(@client)
  end

  def show
    @portfolio = current_trader.portfolios.find(params[:id])
    @stocks = @portfolio.stocks
    @single_stock_portfolio_value = Portfolio.calculate_single_stock_portfolio_value(@portfolio)
    @transactions = @portfolio.transactions.order(created_at: :desc)
    @pagy, @paginated_transactions = pagy(@transactions, items: 4)
    @performance_metrics = calculate_performance_metrics(@portfolio)
    @asset_allocation = calculate_asset_allocation(@portfolio)
    
    fetch_realtime_data_for_stocks([@portfolio])
  end

  private

  def calculate_performance_metrics(portfolio)
    total_investment = portfolio.transactions.where(transaction_type: 'buy').sum(&:price)
    total_investment = total_investment - portfolio.transactions.where(transaction_type: 'sell').sum(&:price)
    current_value = 0
  
    portfolio.stocks.each do |stock|
      quote = @client.quote(stock.ticker_symbol)
      current_value = quote.latest_price * portfolio.number_of_shares
    end
  
    roi = total_investment.zero? ? 0 : ((current_value - total_investment) / total_investment) * 100
    { roi: roi }
  end
  
  def calculate_asset_allocation(portfolio)
    portfolios = current_trader.portfolios
    total_portfolio_value = Portfolio.calculate_total_portfolio_value(portfolios)
    asset_allocation = {}
  
    portfolio.stocks.each do |stock|
      allocation_percentage = (stock.price * portfolio.number_of_shares / total_portfolio_value) * 100
      asset_allocation[stock.ticker_symbol] = allocation_percentage
    end
  
    asset_allocation
  end
  
  def fetch_realtime_data_for_stocks(portfolios)
    stocks = portfolios.flat_map(&:stocks)
    stock_symbols = stocks.map(&:ticker_symbol)

    stock_symbols.each do |stock_symbol|
      quote = @client.quote(stock_symbol)
      stock = stocks.find { |s| s.ticker_symbol == quote.symbol }
      stock.update(price: quote.latest_price)
    end
  end

  def require_trader
    redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
  end
  
end