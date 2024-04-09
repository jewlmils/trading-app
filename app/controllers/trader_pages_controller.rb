class TraderPagesController < ApplicationController

    before_action :authenticate_trader!

    def show
        @trader = current_trader
        @portfolios = @trader.portfolios.includes(:stocks)
        # @stocks = @portfolio.stocks
        # @transactions = @trader.transactions
    end
end