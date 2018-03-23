class AasmCreateMerchantUserRequestedNotifications < ActiveRecord::Migration
  def change
    create_table :merchant_user_requested_notifications do |t|
      t.integer :merchant_user_id
      t.string :aasm_state
      t.text :message

      t.integer :approved_by
      t.datetime :approved_at

      t.integer :rejected_by
      t.datetime :rejected_at
      t.text :rejected_because_of
      
      t.integer :delivered_by
      t.datetime :delivered_at
      
      t.timestamps null: false 
    end
    add_index :merchant_user_requested_notifications, :merchant_user_id
    add_index :merchant_user_requested_notifications, :approved_by
    add_index :merchant_user_requested_notifications, :rejected_by
  end
end
