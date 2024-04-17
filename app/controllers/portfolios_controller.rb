class PortfoliosController < ApplicationController
  before_action :authenticate_trader!
  before_action :set_client

  def index
    @portfolios = current_trader.portfolios
    @total_portfolio_value = calculate_total_portfolio_value(@portfolios)
    @cash_balance = current_trader.wallet
    @quotes = {}

    @portfolios.each do |portfolio|
      portfolio.stocks.each do |stock|
        @quotes[stock.ticker_symbol] = @client.quote(stock.ticker_symbol)
      end
    end
    
    fetch_realtime_data_for_stocks(@portfolios)
  end

  def show
    @portfolio = current_trader.portfolios.find(params[:id])
    @stocks = @portfolio.stocks
    @single_stock_portfolio_value = calculate_single_stock_portfolio_value(@portfolio)
    @transactions = @portfolio.transactions.order(created_at: :desc)
    @performance_metrics = calculate_performance_metrics(@portfolio)
    @asset_allocation = calculate_asset_allocation(@portfolio)
    
    fetch_realtime_data_for_stocks([@portfolio])
  end

  private

  def calculate_total_portfolio_value(portfolios)
    total_value = 0
  
    portfolios.each do |portfolio|
      portfolio.stocks.each do |stock|
        total_value += stock.price * portfolio.number_of_shares
      end
    end
  
    total_value
  end

  def calculate_single_stock_portfolio_value(portfolio)
    total_value = 0

    portfolio.stocks.each do |stock|
      total_value = stock.price * portfolio.number_of_shares
    end
  
    total_value
  end

  def calculate_performance_metrics(portfolio)
    total_investment = portfolio.transactions.where(transaction_type: 'buy').sum(&:price)
    current_value = 0
  
    portfolio.stocks.each do |stock|
      quote = @client.quote(stock.ticker_symbol)
      current_value += quote.latest_price * portfolio.number_of_shares
    end
  
    roi = total_investment.zero? ? 0 : ((current_value - total_investment) / total_investment) * 100
    { roi: roi }
  end
  
  def calculate_asset_allocation(portfolio)
    total_portfolio_value = calculate_single_stock_portfolio_value(portfolio)
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
end