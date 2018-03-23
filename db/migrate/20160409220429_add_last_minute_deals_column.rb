class AddLastMinuteDealsColumn < ActiveRecord::Migration
  def change
  	add_column :deals, :is_last_minute_deal, :boolean, default: false
  	add_column :deals, :last_coupons, :integer
  	add_column :deals, :last_start_time, :time
  	add_column :deals, :last_end_time, :time
  	add_column :deal_categories, :deal_type, :integer, default: 0
  end
end
