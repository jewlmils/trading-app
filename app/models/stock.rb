class Stock < ApplicationRecord
    has_many :portfolio_stocks
    has_many :portfolios, through: :portfolio_stocks
    has_many :transactions
    has_many :stock_prices

    def self.save_to_db(symbol, quote)  
        stock_attributes = {
            ticker_symbol: quote.symbol,
            company_name: quote.company_name,
            price: quote.latest_price
        }

        existing_stock = Stock.find_by(ticker_symbol: symbol)
    
        if existing_stock
            existing_stock.update!(stock_attributes)
        else
            Stock.create!(stock_attributes)
        end
    end
end