class TransactionsController < ApplicationController
  before_action :require_trader
  before_action :set_client                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              

  def index
    @transactions = current_trader.transactions.order(created_at: :desc)
    if params[:search].present?
      @transactions = @transactions.joins(:stock).where("stocks.company_name ILIKE :search_start OR stocks.ticker_symbol ILIKE :search_start", search_start: "#{params[:search]}%")
    end

    @portfolio = current_trader.portfolios
    @cash_balance = current_trader.wallet
  end

  def buy
    @trader = current_trader
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @quantity = params[:quantity].to_i
    @total_price = @quantity * @quote.latest_price

    save_to_db(@symbol, @quote)

    if @trader.wallet >= @total_price
      execute_transaction(@trader, @symbol, @quantity, 'buy', @total_price)

      flash[:notice] = 'Stock purchased successfully.'
    else
      flash[:alert] = 'Insufficient funds to buy the stock.'
    end

    redirect_to stock_path

    rescue IEX::Errors::SymbolNotFoundError => e
      handle_error
  end

  def sell
    @trader = current_trader
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @quantity = params[:quantity].to_i
    portfolio = @trader.portfolios.find_by(stock_id: Stock.find_by(ticker_symbol: @symbol)&.id)
      if portfolio.nil? || portfolio.number_of_shares <= @quantity
        flash[:alert] = "You don't have enough shares to sell."
        redirect_to stock_path
      end
    @total_price = @quantity * @quote.latest_price
    execute_transaction(@trader, @symbol, @quantity, 'sell', @total_price)
    flash[:notice] = 'Stock sold successfully.'
    redirect_to stock_path
    
    rescue IEX::Errors::SymbolNotFoundError => e
      handle_error
  end
  
  private

  def execute_transaction(trader, symbol, quantity, transaction_type, total_price)
    ActiveRecord::Base.transaction do
      if transaction_type == 'buy'
        trader.update!(wallet: trader.wallet - total_price)
      elsif transaction_type == 'sell'
        trader.update!(wallet: trader.wallet + total_price)
      end
  
      create_transaction(trader, symbol, quantity, transaction_type, total_price)
    end
  end

  def create_transaction(trader, symbol, quantity, transaction_type, total_price)
    stock = Stock.find_or_create_by(ticker_symbol: symbol) do |s|
      s.company_name = @quote.company_name
      s.price = @quote.latest_price
    end
    
    stock_price = StockPrice.find_or_create_by(stock_id: stock.id, date: Date.today)
    stock_price.update(current_price: @quote.latest_price)
    portfolio = trader.portfolios.find_or_create_by(stock_id: stock.id)
    portfolio_stock = PortfolioStock.find_or_create_by(portfolio_id: portfolio.id, stock_id: stock.id)

    if transaction_type == 'buy'
      portfolio.update!(number_of_shares: portfolio.number_of_shares + quantity.to_i)
    elsif transaction_type == 'sell'
      portfolio.update!(number_of_shares: portfolio.number_of_shares - quantity.to_i)
    end
  
    Transaction.create!(
      trader_id: trader.id,
      stock_id: stock.id,
      portfolio_id: portfolio.id,
      transaction_type: transaction_type,
      number_of_shares: quantity,
      price: total_price
    )
  end
  
  def save_to_db(symbol, quote)  
    existing_stock = Stock.find_by(ticker_symbol: @symbol)

    if existing_stock
      existing_stock.update!(
        ticker_symbol: quote.symbol,
        company_name: quote.company_name,
        price: quote.latest_price
      )
    else
      Stock.create!(
        ticker_symbol: quote.symbol,
        company_name: quote.company_name,
        price: quote.latest_price
      )
    end
  end

  def handle_error
    flash[:alert] = 'Failed to retrieve stock information from the IEX API.'

    redirect_to stocks_path
  end

  private

  def require_trader
    redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
  end

end