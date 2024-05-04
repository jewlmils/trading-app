class StockPrice < ApplicationRecord
    belongs_to :stock

    def self.update_stock_prices(client, date)
        stocks = Stock.all
      
        stocks.each do |stock|
            stock_price = StockPrice.find_or_create_by(stock_id: stock.id, date: date)
            quote = client.quote(stock.ticker_symbol)
            
            if date == Date.today
                stock_price.update!(current_price: quote.latest_price)
            elsif date == Date.yesterday
                stock_price.update!(current_price: quote.previous_close)
            end
        end
    end
end