class Portfolio < ActiveRecord::Base
  belongs_to :trader
  has_many :portfolio_stocks
  has_many :stocks, through: :portfolio_stocks
  has_many :transactions

  validates :number_of_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  
  def self.calculate_total_portfolio_value(portfolios)
    total_value = 0
  
    portfolios.each do |portfolio|
      portfolio.stocks.each do |stock|
        total_value += stock.price * portfolio.number_of_shares
      end
    end
  
    total_value
  end

  # def self.calculate_single_stock_portfolio_value(portfolio)
  #   total_value = 0

  #   portfolio.stocks.each do |stock|
  #     total_value = stock.price * portfolio.number_of_shares
  #   end
  
  #   total_value
  # end
  
  # def self.cumulative_total_value_by_day
  #   dates_with_transactions = Transaction.pluck(:created_at).map(&:to_date).uniq
  
  #   cumulative_values_by_day = {}
  
  #   dates_with_transactions.each do |date|
  #     total_value = 0
  #     transactions_up_to_date = Transaction.where("DATE(created_at) <= ?", date)
  
  #     transactions_up_to_date.each do |transaction|
  #       stock_price = StockPrice.where(stock_id: transaction.stock_id, date: date).first
  #       if transaction.transaction_type == 'buy'
  #         total_value += transaction.number_of_shares * stock_price.current_price if stock_price
  #       elsif transaction.transaction_type == 'sell'
  #         total_value -= transaction.number_of_shares * stock_price.current_price if stock_price
  #       end
  #     end
  
  #     cumulative_values_by_day[date] = total_value
  #   end
  
  #   cumulative_values_by_day
  # end

  def self.cumulative_total_value_by_day
    end_date = Date.today
  
    cumulative_values_by_day = {}
  
    (Transaction.minimum(:created_at).to_date..end_date).each do |date|
      total_value = 0
  
      transactions_up_to_date = Transaction.where("DATE(created_at) <= ?", date)
  
      transactions_up_to_date.each do |transaction|
        stock_price = StockPrice.where(stock_id: transaction.stock_id, date: date).first
        if transaction.transaction_type == 'buy'
          total_value += transaction.number_of_shares * stock_price.current_price if stock_price
        elsif transaction.transaction_type == 'sell'
          total_value -= transaction.number_of_shares * stock_price.current_price if stock_price
        end
      end
  
      cumulative_values_by_day[date] = total_value
    end
  
    cumulative_values_by_day
  end
  
end
