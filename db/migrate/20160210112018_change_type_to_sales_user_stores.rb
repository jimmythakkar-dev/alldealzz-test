class ChangeTypeToSalesUserStores < ActiveRecord::Migration
  def up
    change_column :sales_user_stores, :latitude, :decimal
    change_column :sales_user_stores, :longitude, :decimal
  end

  def down
    change_column :sales_user_stores, :latitude, :integer
    change_column :sales_user_stores, :longitude, :integer
  end
end
