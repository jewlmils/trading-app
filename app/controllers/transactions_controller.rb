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

  private

  def create_transaction(trader, symbol, quantity, transaction_type, total_price)
    stock = Stock.find_or_create_by(ticker_symbol: symbol) do |s|
      s.company_name = @quote.company_name
      s.price = @quote.latest_price
    end
    # if stock.nil?
    #   puts "Could not find stock with symbol #{symbol}"
    #   return
    # end
  
    # Debugging output to inspect the retrieved stock
    # puts "Found stock: #{stock.inspect}"
    portfolio = trader.portfolios.find_or_create_by(stock_id: stock.id)
    
    # if portfolio.nil?
    #   puts "Could not find portfolio for trader #{trader.id} and stock #{stock.id}"
    #   return
    # end

    # puts "Found portfolio: #{portfolio.inspect}"
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

    if @quote.present?
      Stock.create!(
        ticker_symbol: @quote.symbol,
        company_name: @quote.company_name,
        price: @quote.latest_price
      )
    end
  end

end
