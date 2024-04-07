class Trader < ApplicationRecord
  after_create :send_admin_mail
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

  # if we want for traders cant sign in unless approved by the admin
  def active_for_authentication? 
    super && approved?
  end 
  
  def send_admin_mail
    AdminMailer.new_user_waiting_for_approval(email).deliver
  end
end
