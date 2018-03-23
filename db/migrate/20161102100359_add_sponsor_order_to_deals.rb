class AddSponsorOrderToDeals < ActiveRecord::Migration
  def change
    add_column :deals, :sponsor_order, :integer
  end
end
