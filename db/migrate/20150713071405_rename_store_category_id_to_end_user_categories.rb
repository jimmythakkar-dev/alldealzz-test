class RenameStoreCategoryIdToEndUserCategories < ActiveRecord::Migration
  def up
    rename_column :end_user_categories, :store_category_id, :deal_category_id
  end
  def down
    rename_column :end_user_categories, :deal_category_id, :store_category_id
  end
end
