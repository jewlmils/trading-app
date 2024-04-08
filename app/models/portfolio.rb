class Portfolio < ActiveRecord::Base
  belongs_to :trader
  has_many :portfolio_stocks
  has_many :stocks, through: :portfolio_stocks

  validates :shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

end
