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

  def self.total_value_by_day
    joins(:stocks)
      .group("DATE(portfolios.created_at)")
      .sum("stocks.price * portfolios.number_of_shares")
  end

  def self.cumulative_total_value_by_day
    date_series = (Stock.minimum(:created_at).to_date..Stock.maximum(:updated_at).to_date).to_a
    total_value = 0
    cumulative_values = {}

    date_series.each do |date|
      total_value += total_value_by_day[date] || 0
      cumulative_values[date] = total_value
    end

    cumulative_values
  end

end