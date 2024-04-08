class Trader < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
   
  has_many :portfolios
  has_many :stock, through: :portfolios

  validates :first_name, presence: true
  validates :last_name, presence: true

  scope :sorted, -> { order(Arel::Table.new(:traders)[:created_at].desc.nulls_first).order(updated_at: :desc) }

  def confirmation_required?
    !admin_created? && super
  end

  def active_for_authentication? 
    super && approved?
  end 
  
end
