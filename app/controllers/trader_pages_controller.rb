class TraderPagesController < ApplicationController
    before_action :require_trader
    before_action :set_client

    def show
        @trader = current_trader
        @portfolios = @trader.portfolios
        @stocks = @portfolios.flat_map(&:stocks)
        @transactions = @trader.transactions
    end

    def deposit
        deposit_amount = params[:amount].to_f
        if deposit_amount <= 0
          redirect_to root_path, alert: 'Deposit amount must be greater than zero.'
          return
        end
    
        current_trader.update(wallet: current_trader.wallet + deposit_amount)
        redirect_to root_path, notice: 'Deposit successful!'
    end
  
  private
    
    def require_trader
        redirect_to root_path, alert: "You are not authorized to access this page." unless trader_signed_in?
    end
end