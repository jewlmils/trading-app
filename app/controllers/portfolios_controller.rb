class PortfoliosController < ApplicationController
    before_action :authenticate_trader!
    before_action :set_client

    def show
        @trader = current_trader
        @portfolios = @trader.portfolios
        @stocks = @portfolios.flat_map(&:stocks)

        @quotes = {}
        @stocks.each do |stock|
            @quotes[stock.ticker_symbol] = @client.quote(stock.ticker_symbol)
        end
    end
end
