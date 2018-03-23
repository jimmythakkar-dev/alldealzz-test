class AddIconUrlToDealCategories < ActiveRecord::Migration
  def change
    add_column :deal_categories, :icon_url, :string
  end
end
