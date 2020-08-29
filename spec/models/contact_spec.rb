require 'rails_helper'

RSpec.describe Contact, type: :model do
  describe '集約クエリの作成' do
    let!(:product_01){ FactoryBot.create(:product, id: 1) }
    let!(:product_02){ FactoryBot.create(:product, id: 2) }
    let!(:account_01){ FactoryBot.create(:account, id: 1) }
    let!(:account_02){ FactoryBot.create(:account, id: 2) }
    let!(:account_03){ FactoryBot.create(:account, id: 3) }
    let!(:contact_01){ FactoryBot.create(:contact, product_id: product_01.id, account_id: account_01.id) }
    let!(:contact_02){ FactoryBot.create(:contact, product_id: product_02.id, account_id: account_02.id) }
    let!(:contact_03){ FactoryBot.create(:contact, product_id: product_02.id, account_id: account_03.id) }

    it '製品毎のアカウント数を取得すること' do
      query = <<-"EOS"
        SELECT product_id, COUNT(*) AS accounts_per_product
        FROM Contacts
        GROUP BY product_id;
      EOS

      expect(ActiveRecord::Base.connection.select_all(query).to_a).to eq Contact.accounts_per_product.map{ |contact| contact.attributes.except('id')}
      expect(Contact.accounts_per_product.map{ |contact| contact.attributes.except('id')}).to eq [{"accounts_per_product"=>1, "product_id"=>1}, {"accounts_per_product"=>2, "product_id"=>2}]
    end

    it 'アカウント毎の製品数を取得すること' do
      query = <<-"EOS"
        SELECT account_id, COUNT(*) AS products_per_account
        FROM Contacts
        GROUP BY account_id;
      EOS

      expect(ActiveRecord::Base.connection.select_all(query).to_a).to eq Contact.products_per_account.map{ |contact| contact.attributes.except('id')}
      expect(Contact.products_per_account.map{ |contact| contact.attributes.except('id')}).to eq [{"account_id"=>1, "products_per_account"=>1}, {"account_id"=>2, "products_per_account"=>1}, {"account_id"=>3, "products_per_account"=>1}]
    end

    it '最も関連アカウント数の多い製品を取得すること' do
      query = <<-"EOS"
        SELECT c.product_id, c.accounts_per_product
        FROM (
          SELECT product_id, COUNT(*) AS accounts_per_product
          FROM Contacts
          GROUP BY product_id
        ) AS c
        HAVING c.accounts_per_product = MAX(c.accounts_per_product)
      EOS

      # ActiveRecord::Base.connection.select_all(query)
      expect(Contact.products_with_the_most_related_accounts.map(&:product_id)).to eq [2]
    end
  end

end
