require 'rails_helper'

RSpec.describe Product, type: :model do


  describe '特定の製品に関するアカウントの検索' do

    let!(:product_01){ FactoryBot.create(:product, id: 123) }
    let!(:product_02){ FactoryBot.create(:product) }
    let!(:account_01){ FactoryBot.create(:account) }
    let!(:account_02){ FactoryBot.create(:account) }
    let!(:account_03){ FactoryBot.create(:account) }
    let!(:account_04){ FactoryBot.create(:account) }
    let!(:contact_01){ FactoryBot.create(:contact, product_id: product_01.id, account_id: account_01.id) }
    let!(:contact_02){ FactoryBot.create(:contact, product_id: product_01.id, account_id: account_02.id) }
    let!(:contact_03){ FactoryBot.create(:contact, product_id: product_02.id, account_id: account_03.id) }
    let!(:contact_04){ FactoryBot.create(:contact, product_id: product_02.id, account_id: account_04.id) }

    it '特定の製品に関するすべてのアカウントを取得すること' do
      query = <<-"EOS"
        SELECT a.*
        FROM Accounts AS a INNER JOIN Contacts AS c ON a.id = c.account_id
        WHERE c.product_id = 123
      EOS

      expect(ActiveRecord::Base.connection.select_all(query).to_a).to eq Product.find(123).accounts.map(&:attributes)
      expect(Product.find(123).accounts.count).to eq 2
    end
  end


end
