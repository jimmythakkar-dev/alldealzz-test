class AddCityToAssociatedTables < ActiveRecord::Migration
  def change
    add_column :stores, :city_id, :integer
    add_column :malls, :city_id, :integer
    add_column :end_users, :city_id, :integer
  end
end
