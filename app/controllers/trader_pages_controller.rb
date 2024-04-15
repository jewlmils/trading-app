class TraderPagesController < ApplicationController
    before_action :authenticate_trader!
    before_action :set_client

    def show
        @trader = current_trader
        @portfolios = @trader.portfolios
        @stocks = @portfolios.flat_map(&:stocks)
    end
end