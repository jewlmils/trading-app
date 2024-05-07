class PortfoliosController < ApplicationController
    before_action :require_trader
    before_action :set_client

    def index
        @trader_id = current_trader.id
        @portfolios = current_trader.portfolios
        @pagy, @paginated_portfolios = pagy(@portfolios, items: 3)

        fetch_stock_data(@portfolios)
        fetch_realtime_stocks_data(@portfolios)
        
        StockPrice.update_stock_prices(@client, Date.today)
        StockPrice.update_stock_prices(@client, Date.yesterday)
        
        @total_portfolio_value = Portfolio.calculate_total_portfolio_value(@portfolios)
        @total_gain_loss = Portfolio.total_gain_loss(@portfolios)
        @portfolio_total_value_by_day = Portfolio.cumulative_total_value_by_day(@trader_id)
    end
  
    def show
        @portfolios = current_trader.portfolios
        @portfolio = @portfolios.find(params[:id])
        @stocks = @portfolio.stocks

        @transactions = @portfolio.transactions.order(created_at: :desc)
        @pagy, @paginated_transactions = pagy(@transactions, items: 4)

        @single_stock_portfolio_value = Portfolio.calculate_single_stock_portfolio_value(@portfolio)
        @gain_loss = Portfolio.calculate_gain_loss_per_stock(@portfolio)
        @roi = Portfolio.calculate_roi(@portfolio, @client)
        @asset_allocation = Portfolio.calculate_asset_allocation(@portfolio, @portfolios)
    end
  
    private

    def fetch_stock_data(portfolios)
        @quotes = {}
        @ohlc = {}
      
        portfolios.each do |portfolio|
            portfolio.stocks.each do |stock|
                @quotes[stock.ticker_symbol] = @client.quote(stock.ticker_symbol)
                @ohlc[stock.ticker_symbol] = @client.ohlc(stock.ticker_symbol)
            end
        end
    end
  
    def fetch_realtime_stocks_data(portfolios)
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