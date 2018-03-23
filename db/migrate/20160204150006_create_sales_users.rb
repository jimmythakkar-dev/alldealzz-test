class CreateSalesUsers < ActiveRecord::Migration
  def change
    create_table :sales_users do |t|
      t.string :identifier, unique: true, null: false
      t.string :password
      t.string :name
      t.string :contact_phone
      t.boolean :status, default: true

      t.timestamps null: false
    end
  end
end
