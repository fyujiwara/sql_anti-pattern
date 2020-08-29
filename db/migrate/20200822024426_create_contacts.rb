class CreateContacts < ActiveRecord::Migration[6.0]
  def change
    create_table :contacts do |t|
      opts = { null: false, foreign_key: true }
      t.references :account, **opts
      t.references :product, **opts

      t.timestamps
    end
  end
end
