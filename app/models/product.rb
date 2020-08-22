class Product < ApplicationRecord
  validates :account_id, presence: true
  validates :product_name, presence: true

end
