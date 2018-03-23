class CreateMerchantUsers < ActiveRecord::Migration
  def change
    create_table :merchant_users do |t|
      t.string  :identifier, unique: true, null: false
      t.string  :password
      t.string  :name
      t.boolean  :status, default: true
      t.integer  :store_id

      t.timestamps null: false
    end
  end
end
