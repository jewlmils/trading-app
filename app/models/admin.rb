class Admin < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable, :recoverable, :registerable, :rememberable, :validatable
  devise :database_authenticatable, :recoverable, :rememberable, :validatable

  validates :email, presence: true
end
