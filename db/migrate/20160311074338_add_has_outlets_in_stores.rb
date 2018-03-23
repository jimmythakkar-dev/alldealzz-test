class AddHasOutletsInStores < ActiveRecord::Migration
  def change
  	add_column :stores, :has_outlets, :boolean,null: false, default: false
  end
end
