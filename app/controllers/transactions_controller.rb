class TransactionsController < ApplicationController
    before_action :require_trader
    before_action :set_client                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                              
  
    def index
        @transactions = current_trader.transactions.order(created_at: :desc)
        if params[:search].present?
            @search_term = params[:search]
            searched_transactions = @transactions.joins(:stock).where("stocks.company_name ILIKE :search_start OR stocks.ticker_symbol ILIKE :search_start", search_start: "#{params[:search]}%")

            if searched_transactions.empty?
                @transactions = current_trader.transactions.order(created_at: :desc)
                flash[:alert] = "No results found for '#{@search_term}'"
            else
                @transactions = searched_transactions
            end
        end

        @pagy, @paginated_transactions = pagy(@transactions, items: 5)

        @cash_balance = current_trader.wallet
    end
  
    def buy
        set_transaction_data
    
        if current_trader.wallet >= @total_price
            begin
                Transaction.execute_transaction(@quote, current_trader, @symbol, @quantity, 'buy', @total_price)
                flash[:notice] = 'Yay! Stock purchased successfully. It\'s gonna be a great investment!'
                redirect_to portfolios_path
            rescue ActiveRecord::RecordInvalid
                flash[:alert] = 'It seems like you entered an invalid number of shares. Try again!'
                redirect_to stock_path
            end
        else
            flash[:alert] = 'Oops! Insufficient funds to buy the stock. Top up your wallet!'
            redirect_to stock_path
        end
    
        rescue IEX::Errors::SymbolNotFoundError
            handle_error
    end
  
    def sell
        set_transaction_data

        portfolio = current_trader.portfolios.find_by(stock_id: Stock.find_by(ticker_symbol: @symbol)&.id)
        
        if portfolio.nil? || portfolio.number_of_shares <= @quantity
            flash[:alert] = "Looks like you're running low on shares. Time to stock up before selling!"
            redirect_to stock_path
        end
        
        Transaction.execute_transaction(@quote, current_trader, @symbol, @quantity, 'sell', @total_price)
            flash[:notice] = 'Stock successfully sold! Keep the profits rolling in!'
            redirect_to portfolios_path
        rescue ActiveRecord::RecordInvalid
            handle_error('It seems like you entered an invalid number of shares. Try again!')
            redirect_to stock_path
        
        rescue IEX::Errors::SymbolNotFoundError
            handle_error("Uh-oh! We couldn't find that symbol. Please check the symbol and try again.")
    end
    
    private

    def set_transaction_data
        @symbol = params[:id]
        @quote = @client.quote(@symbol)
        @quantity = params[:quantity].to_i
        @total_price = @quantity * @quote.latest_price
    end
  
    def handle_error(message)
        flash[:alert] = message
        redirect_to stocks_path
    end

    def require_trader
        redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
    end
end