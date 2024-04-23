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

  def self.calculate_single_stock_portfolio_value(portfolio)
    total_value = 0

    portfolio.stocks.each do |stock|
      total_value = stock.price * portfolio.number_of_shares
    end
  
    total_value
  end

  # def self.total_value_by_day
  #   joins(:stocks)
  #     .group("DATE(portfolios.created_at)")
  #     .sum("stocks.price * portfolios.number_of_shares")
  # end

  # def self.cumulative_total_value_by_day
  #   date_series = (Stock.minimum(:created_at).to_date..Stock.maximum(:updated_at).to_date).to_a
  #   total_value = 0
  #   cumulative_values = {}

  #   date_series.each do |date|
  #     total_value += total_value_by_day[date] || 0
  #     cumulative_values[date] = total_value
  #   end

  #   cumulative_values
  # end
  
  # def self.cumulative_total_value_by_day
  #   # Get all unique dates present in the transactions
  #   dates_with_transactions = Transaction.pluck(:created_at).map(&:to_date).uniq
  
  #   # Initialize a hash to store the cumulative total value for each date
  #   cumulative_values_by_day = {}
  
  #   # Loop through each unique date and calculate the cumulative total value for that date
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
    # Define the subquery to calculate total buy and sell values per day
    subquery = Transaction.select("
      DATE(transactions.created_at) AS transaction_date,
      SUM(
        CASE 
          WHEN transactions.transaction_type = 'buy' THEN stock_prices.current_price * transactions.number_of_shares 
          ELSE 0 
        END
      ) AS total_buy_value,
      SUM(
        CASE 
          WHEN transactions.transaction_type = 'sell' THEN stock_prices.current_price * transactions.number_of_shares 
          ELSE 0 
        END
      ) AS total_sell_value
    ")
    .joins(portfolio: { portfolio_stocks: :stock })
    .joins("LEFT JOIN stock_prices ON stocks.id = stock_prices.stock_id AND DATE(transactions.created_at) = DATE(stock_prices.created_at)")
    .group("DATE(transactions.created_at)")
  
    # Define the main query using a Common Table Expression (CTE) to reference the subquery
    query = <<-SQL
      WITH buy_sell_values AS (
        #{subquery.to_sql}
      )
      SELECT 
        transaction_date,
        SUM(total_buy_value) OVER (ORDER BY transaction_date) - SUM(total_sell_value) OVER (ORDER BY transaction_date) AS net_cumulative_value
      FROM 
        buy_sell_values
    SQL
  
    # Execute the query and convert the result to a hash for easier access
    ActiveRecord::Base.connection.execute(query).to_a.map { |record| [record['transaction_date'], record['net_cumulative_value'].to_f] }.to_h
  end  
end
