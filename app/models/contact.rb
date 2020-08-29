class Contact < ApplicationRecord
  belongs_to :account
  belongs_to :product

  scope :accounts_per_product, -> {
    group(:product_id)
        .select('product_id, count(*) as accounts_per_product')
  }

  scope :products_per_account, -> {
    group(:account_id)
        .select('account_id, count(*) as products_per_account')
  }

  scope :products_with_the_most_related_accounts, -> {
    accounts_per_product
        .having('accounts_per_product = ?', group(:product_id).count.values.max)
  }

end
