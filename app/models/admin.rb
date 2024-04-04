class Admin < ApplicationRecord
  has_many :users

  # has_many :transactions, through: :users
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable,
        # :registerable,
         :recoverable, :rememberable, :validatable
end