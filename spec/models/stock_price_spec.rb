require 'rails_helper'

RSpec.describe StockPrice, type: :model do
    describe '.update_stock_prices_for_today' do
        it 'updates stock prices for today' do
            stock = FactoryBot.create(:stock)
            client = double('IEX::Api::Client')

            allow(client).to receive(:quote).and_return(double('quote', latest_price: 400.96))

            StockPrice.update_stock_prices_for_today(client)

            puts "Current price for #{stock.ticker_symbol}: #{stock.stock_prices.first.current_price}"
            
            expect(stock.stock_prices.first.current_price).to eq(400.96)
        end
    end

    describe '.update_stock_prices_for_yesterday' do
        it 'updates stock prices for yesterday' do
            stock = FactoryBot.create(:stock)
            client = double('IEX::Api::Client')

            allow(client).to receive(:quote).and_return(double('quote', previous_close: 407.57))

            StockPrice.update_stock_prices_for_yesterday(client)

            puts "Previous close price for #{stock.ticker_symbol}: #{stock.stock_prices.first.current_price}"
            
            expect(stock.stock_prices.first.current_price).to eq(407.57)
        end
    end
end
