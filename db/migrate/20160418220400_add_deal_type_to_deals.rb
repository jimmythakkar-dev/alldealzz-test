class AddDealTypeToDeals < ActiveRecord::Migration
  def change
  	remove_column :deals, :is_last_minute_deal, :boolean, default: false
  	add_column :deals, :deal_type, :integer, default: 0
  end
end
