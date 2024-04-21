class Stock < ActiveRecord::Base
    has_many :portfolio_stocks
    has_many :portfolios, through: :portfolio_stocks
    has_many :transactions
    has_many :stock_prices
end