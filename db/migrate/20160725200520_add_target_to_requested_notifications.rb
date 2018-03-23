class AddTargetToRequestedNotifications < ActiveRecord::Migration
  def change
  	add_column :requested_notifications, :target_doorkeeper_access_token_id, :integer
  	add_column :requested_notifications, :target_distance, :float
  end
end
