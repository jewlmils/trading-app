class StocksController < ApplicationController
    before_action :require_trader
    before_action :set_client
    before_action :search_stocks, only: [:index]
  
    def index
        @search_keyword = params[:symbol]
        @quote = @search_keyword.present? ? search_stocks(@search_keyword) : nil
        @symbol = params[:id]
    end
  
    private
  
    def search_stocks(keyword = nil)
        return unless keyword
        
        @client.quote(keyword)
    rescue IEX::Errors::SymbolNotFoundError => e
        handle_iex_error(e)
        nil
    end
  
    def require_trader
        redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
    end
end