class ChangeTypeLatitudeAndLongitudeToEndUsers < ActiveRecord::Migration
  def up
    change_column :end_users, :latitude, :decimal
    change_column :end_users, :longitude, :decimal
  end

  def down
    change_column :end_users, :longitude, :integer
    change_column :end_users, :latitude, :integer
  end
end
