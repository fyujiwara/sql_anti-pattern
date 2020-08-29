class Product < ApplicationRecord
  has_many :contacts
  has_many :accounts, through: :contacts

  validates :product_name, presence: true

end
