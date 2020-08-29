class Account < ApplicationRecord
  has_many :contacts
  has_many :products, through: :contacts
end
