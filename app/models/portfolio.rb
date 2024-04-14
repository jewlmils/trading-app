class Portfolio < ActiveRecord::Base
  belongs_to :trader
  has_many :portfolio_stocks
  belongs_to :stock
  has_many :transactions

  validates :number_of_shares, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
end
