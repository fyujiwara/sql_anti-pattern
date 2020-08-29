require 'rails_helper'

RSpec.describe Account, type: :model do
  describe '特定のアカウントに関する製品の検索' do

    let!(:account_01){ FactoryBot.create(:account, id: 12) }
    let!(:account_02){ FactoryBot.create(:account) }
    let!(:product_01){ FactoryBot.create(:product) }
    let!(:product_02){ FactoryBot.create(:product) }
    let!(:product_03){ FactoryBot.create(:product) }
    let!(:product_04){ FactoryBot.create(:product) }
    let!(:contact_01){ FactoryBot.create(:contact, account_id: account_01.id, product_id: product_01.id) }
    let!(:contact_02){ FactoryBot.create(:contact, account_id: account_01.id, product_id: product_02.id) }
    let!(:contact_03){ FactoryBot.create(:contact, account_id: account_02.id, product_id: product_03.id) }
    let!(:contact_04){ FactoryBot.create(:contact, account_id: account_02.id, product_id: product_04.id) }

    it '特定のアカウントに関するすべての製品を取得すること' do
      query = <<-"EOS"
        SELECT p.*
        FROM Products AS p INNER JOIN Contacts AS c ON p.id = c.product_id
        WHERE c.account_id = 12
      EOS

      expect(ActiveRecord::Base.connection.select_all(query).to_a).to eq Account.find(12).products.map(&:attributes)
      expect(Account.find(12).products.count).to eq 2
    end

  end
end
