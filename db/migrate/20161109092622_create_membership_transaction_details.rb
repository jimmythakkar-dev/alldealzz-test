class CreateMembershipTransactionDetails < ActiveRecord::Migration
  def change
    create_table :membership_transaction_details do |t|
      t.integer :club_membership_detail_id
      t.integer :end_user_id
      t.integer :payment_status, default: 0
      t.string :payu_id

      t.timestamps null: false
    end
  end
end
