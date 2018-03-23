class AddCityIdToRequestedNotifications < ActiveRecord::Migration
  def change
    add_column :requested_notifications, :city_id, :integer
  end
end
