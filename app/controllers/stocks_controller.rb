class StocksController < ApplicationController
    before_action :require_trader
    before_action :set_client
  
    def index
        @search_keyword = params[:symbol]

        begin
            @quote = @search_keyword.present? ? @client.quote(@search_keyword) : nil
        rescue IEX::Errors::SymbolNotFoundError
            handle_error
        end

        @symbol = params[:id]
    end
  
    private

    def handle_error
        flash[:alert] = "Uh-oh! We couldn't find that symbol. Please check the symbol and try again."
        redirect_to stocks_path
    end
    
    def require_trader
        redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
    end
end