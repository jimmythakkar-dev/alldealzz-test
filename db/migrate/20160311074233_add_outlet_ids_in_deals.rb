class AddOutletIdsInDeals < ActiveRecord::Migration
  def change
  	add_column :deals, :outlet_ids, :string
  end
end
