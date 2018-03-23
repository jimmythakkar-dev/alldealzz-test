class CreateEndUserUsedDeals < ActiveRecord::Migration
  def change
  	create_table :end_user_used_deals do |t|
			t.integer :end_user_id, null: false
			t.integer :deal_id, null: false

			t.timestamps null: false
		end
		add_index :end_user_used_deals, :end_user_id
    add_index :end_user_used_deals, :deal_id
    add_index :end_user_used_deals, [:end_user_id, :deal_id], unique: true
  end
end
