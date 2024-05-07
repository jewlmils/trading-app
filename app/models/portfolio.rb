class Portfolio < ApplicationRecord
    belongs_to :trader
    has_many :portfolio_stocks
    has_many :stocks, through: :portfolio_stocks
    has_many :transactions
  
    validates :number_of_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
    
    def self.calculate_gain_loss_per_stock(portfolio)
        total_buy_cost = portfolio.transactions.where(transaction_type: 'buy').sum(&:price)
        current_value = calculate_single_stock_portfolio_value(portfolio)
        gain_loss = current_value - total_buy_cost
    end

    def self.total_gain_loss(portfolios)
        total_gain_loss = 0

        portfolios.each do |portfolio|
          total_gain_loss += calculate_gain_loss_per_stock(portfolio)
        end

        total_gain_loss
    end
    
    def self.calculate_total_portfolio_value(portfolios)
        total_value = 0
        
        portfolios.each do |portfolio|
            portfolio.stocks.each do |stock|
                total_value += stock.price * portfolio.number_of_shares
            end
        end
        
        total_value
    end
  
    def self.calculate_single_stock_portfolio_value(portfolio)
        total_value = 0
    
        portfolio.stocks.each do |stock|
            total_value = stock.price * portfolio.number_of_shares
        end
        
        total_value
    end
  
    def self.calculate_roi(portfolio, client)
        total_buy_investment = portfolio.transactions.where(transaction_type: 'buy').sum(&:price)
        total_sell_investment = portfolio.transactions.where(transaction_type: 'sell').sum(&:price)
        total_investment = total_buy_investment - total_sell_investment

        current_value = 0
        
        portfolio.stocks.each do |stock|
            quote = client.quote(stock.ticker_symbol)
            current_value = quote.latest_price * portfolio.number_of_shares
        end
        
        roi = total_investment.zero? ? 0 : ((current_value - total_investment) / total_investment) * 100
    end
  
    def self.calculate_asset_allocation(portfolio, portfolios)
        total_portfolio_value = calculate_total_portfolio_value(portfolios)
        
        asset_allocation = {}
        
        portfolio.stocks.each do |stock|
            allocation_percentage = (stock.price * portfolio.number_of_shares / total_portfolio_value) * 100
            asset_allocation[stock.ticker_symbol] = allocation_percentage
        end
        
        asset_allocation
    end
  
    # def self.cumulative_total_value_by_day
    #     end_date = Date.today
        
    #     cumulative_values_by_day = {}
        
    #     (Transaction.minimum(:created_at).to_date..end_date).each do |date|
    #         total_value = 0
        
    #         transactions_up_to_date = Transaction.where("DATE(created_at) <= ?", date)
        
    #         transactions_up_to_date.each do |transaction|
    #             stock_price = StockPrice.where(stock_id: transaction.stock_id, date: date).first

    #             if transaction.transaction_type == 'buy'
    #                 total_value += transaction.number_of_shares * stock_price.current_price if stock_price
    #             elsif transaction.transaction_type == 'sell'
    #                 total_value -= transaction.number_of_shares * stock_price.current_price if stock_price
    #             end
    #         end
        
    #     cumulative_values_by_day[date] = total_value
    #   end
    
    #   cumulative_values_by_day
    # end

    def self.cumulative_total_value_by_day(trader_id)
        end_date = Date.today
        cumulative_values_by_day = {}
        
        start_date = Transaction.where(trader_id: trader_id).minimum(:created_at)&.to_date || end_date
      
        return cumulative_values_by_day if start_date > end_date
      
        (start_date..end_date).each do |date|
            total_value = 0
            transactions_up_to_date = Transaction.where(trader_id: trader_id).where("DATE(created_at) <= ?", date)
        
            next if transactions_up_to_date.empty?
        
            transactions_up_to_date.each do |transaction|
                stock_price = StockPrice.where(stock_id: transaction.stock_id, date: date).first
        
                if transaction.transaction_type == 'buy' && stock_price
                    total_value += transaction.number_of_shares * stock_price.current_price
                elsif transaction.transaction_type == 'sell' && stock_price
                    total_value -= transaction.number_of_shares * stock_price.current_price
                end
            end
        
            cumulative_values_by_day[date] = total_value
        end
      
        cumulative_values_by_day
    end
end  