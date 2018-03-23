class CreateTransactionDetails < ActiveRecord::Migration
  def change
    create_table :transaction_details do |t|
      t.string :bank_ref_id
      t.text :product_info
      t.string :payu_id
      t.string :payu_hash
      t.integer :payment_status, default: 0
      t.integer :settlement_status, default: 0
      t.date :settlement_date
      t.integer :quantity
      t.decimal :total_amount, precision:  10, scale:  2

      t.timestamps null: false
    end
  end
end
