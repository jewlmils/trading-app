class Transaction < ApplicationRecord
  belongs_to :trader
  belongs_to :stock
  belongs_to :portfolio
end
