class AddColumnsToEndUserUsedDeals < ActiveRecord::Migration
  def change
    add_column :end_user_used_deals, :booking_code_id, :integer
    add_column :end_user_used_deals, :used_status, :boolean, default: false

    remove_index :end_user_used_deals, :end_user_id
    remove_index :end_user_used_deals, :deal_id
    remove_index :end_user_used_deals, [:end_user_id, :deal_id]
  end
end
