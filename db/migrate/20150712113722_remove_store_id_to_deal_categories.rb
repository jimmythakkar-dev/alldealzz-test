class RemoveStoreIdToDealCategories < ActiveRecord::Migration
  def up
  	remove_column :deal_categories, :store_id
  end

  def down
  	add_column :deal_categories, :store_id, :integer
  end
end
