class CreateProducts < ActiveRecord::Migration[6.0]
  def change
    create_table :products do |t|
      t.text :account_id, null: false
      t.string :product_name, null: false

      t.timestamps
    end
  end
end
