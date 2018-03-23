class AddColumnsToEndUserUsedDeal < ActiveRecord::Migration
  def change
    add_column :end_user_used_deals, :time_slot_start_time, :time
    add_column :end_user_used_deals, :time_slot_end_time, :time
    add_column :end_user_used_deals, :phone_number, :string
    add_column :end_user_used_deals, :number_of_guests, :integer
  end
end
