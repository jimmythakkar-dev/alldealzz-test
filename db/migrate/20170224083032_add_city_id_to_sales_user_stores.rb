class AddCityIdToSalesUserStores < ActiveRecord::Migration
  def change
    add_column :sales_user_stores, :city_id, :integer
  end
end
