class Trader < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :confirmable
   
  has_many :portfolios
  has_many :stock, through: :portfolios
  has_many :transactions

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :wallet, numericality: { greater_than_or_equal_to: 0 }

  scope :sorted, -> { order(Arel::Table.new(:traders)[:created_at].desc.nulls_first).order(updated_at: :desc) }

  def confirmation_required?
    !admin_created? && super
  end

  def active_for_authentication? 
    super && approved?
  end 
  
  def self.ransackable_associations(auth_object = nil)
    ["id", "first_name", "last_name", "email"]
  end

  def self.ransackable_attributes(auth_object = nil)
    %w[first_name last_name email]
  end
end
