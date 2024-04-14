class TransactionsController < ApplicationController
  before_action :authenticate_trader!
  before_action :set_client

  def buy
    @trader = current_trader
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @price_per_share = @quote.latest_price
    @total_price = params[:quantity].to_i * @price_per_share
    puts "Before save"
    save_to_db

    if @trader.wallet >= @total_price
      ActiveRecord::Base.transaction do
        @trader.update!(wallet: @trader.wallet - @total_price)
        create_transaction(@trader, @symbol, params[:quantity], 'buy', @total_price)
      end

      flash[:notice] = 'Stock purchased successfully.'
    else
      flash[:alert] = 'Insufficient funds to buy the stock.'
    end

    redirect_to stocks_path
  rescue IEX::Errors::SymbolNotFoundError => e
    flash[:alert] = 'Failed to retrieve stock information from the IEX API.'
    redirect_to stocks_path
  end

  def sell
    @trader = current_trader
    @symbol = params[:id]
    @quote = @client.quote(@symbol)
    @price_per_share = @quote.latest_price
    @quantity = params[:quantity].to_i
  
    portfolio = @trader.portfolios.find_by(stock_id: Stock.find_by(ticker_symbol: @symbol)&.id)
    if portfolio.nil? || portfolio.number_of_shares <= @quantity
      flash[:alert] = "You don't have enough shares to sell."
      redirect_to stocks_path
      return
    end
  
    @total_price = @quantity * @price_per_share
  
    ActiveRecord::Base.transaction do
      @trader.update!(wallet: @trader.wallet + @total_price)
      create_transaction(@trader, @symbol, @quantity, 'sell', @total_price)
    end
  
    flash[:notice] = 'Stock sold successfully.'
    redirect_to stocks_path
  rescue IEX::Errors::SymbolNotFoundError => e
    flash[:alert] = 'Failed to retrieve stock information from the IEX API.'
    redirect_to stocks_path
  end
  

  private

  def create_transaction(trader, symbol, quantity, transaction_type, total_price)
    stock = Stock.find_or_create_by(ticker_symbol: symbol) do |s|
      s.company_name = @quote.company_name
      s.price = @quote.latest_price
    end
    
    portfolio = trader.portfolios.find_or_create_by(stock_id: stock.id)
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
  
  def save_to_db
    puts "SAVE"
    @symbol = params[:id]
    @quote = @client.quote(@symbol)

    existing_stock = Stock.find_by(ticker_symbol: @symbol)

    if existing_stock
      existing_stock.update!(
        company_name: @quote.company_name,
        price: @quote.latest_price
      )
    else
      Stock.create!(
        ticker_symbol: @quote.symbol,
        company_name: @quote.company_name,
        price: @quote.latest_price
      )
    end
  end

end
