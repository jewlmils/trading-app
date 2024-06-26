class Transaction < ApplicationRecord
    belongs_to :trader
    belongs_to :stock
    belongs_to :portfolio

    validates :number_of_shares, presence: true, numericality: { only_integer: true, greater_than: 0 }
    
    def self.execute_transaction(quote, trader, symbol, quantity, transaction_type, total_price)
        Transaction.transaction do
            trader.update!(wallet: trader.wallet + (transaction_type == 'buy' ? -total_price : total_price))

            create_transaction_record(quote, trader, symbol, quantity, transaction_type, total_price)
        end
    end 
    
    def self.create_transaction_record(quote, trader, symbol, quantity, transaction_type, total_price)
        stock = Stock.find_or_create_by(ticker_symbol: symbol) do |s|
            s.company_name = quote.company_name
            s.price = quote.latest_price
        end
        stock.update!(price: quote.latest_price)
        
        stock_price = StockPrice.find_or_create_by(stock_id: stock.id, date: Date.today)
        stock_price.update!(current_price: quote.latest_price)

        portfolio = trader.portfolios.find_or_create_by(stock_id: stock.id)
        portfolio.update!(number_of_shares: portfolio.number_of_shares + (transaction_type == 'buy' ? quantity.to_i : -quantity.to_i))

        portfolio_stock = PortfolioStock.find_or_create_by(portfolio_id: portfolio.id, stock_id: stock.id)        
        
        Transaction.create!(
            trader_id: trader.id,
            stock_id: stock.id,
            portfolio_id: portfolio.id,
            transaction_type: transaction_type,
            number_of_shares: quantity,
            price: total_price
        )
    end
end