class StockPrice < ApplicationRecord
  belongs_to :stock

  def self.update_stock_prices_for_today(client)
    stocks = Stock.all

    stocks.each do |stock|
      stock_price = StockPrice.find_or_create_by(stock_id: stock.id, date: Date.today)
      quote = client.quote(stock.ticker_symbol)
      stock_price.update(current_price: quote.latest_price)
    end
  end
end
