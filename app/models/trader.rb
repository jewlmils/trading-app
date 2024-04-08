class Trader < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
   
  validates :first_name, presence: true
  validates :last_name, presence: true

  def confirmation_required?
    !admin_created? && super
  end

  def active_for_authentication? 
    super && approved?
  end 
  
end
