class AddPriorityOrderToDealCategories < ActiveRecord::Migration
  def change
    add_column :deal_categories, :priority_order, :integer
  end
end
