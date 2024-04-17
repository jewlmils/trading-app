class TraderPagesController < ApplicationController
    before_action :require_trader
    before_action :set_client

    def show
        @trader = current_trader
        @portfolios = @trader.portfolios
        @stocks = @portfolios.flat_map(&:stocks)
        @transactions = @trader.transactions
    end

    private
    
    def require_trader
        redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
    end
end