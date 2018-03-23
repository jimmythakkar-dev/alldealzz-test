class AppTypeToRailsPushNotifications < ActiveRecord::Migration
  def change
  	add_column :rails_push_notifications_gcm_apps, :app_type, :string, default: 'end_user'
  	add_column :rails_push_notifications_apns_apps, :app_type, :string, default: 'end_user'
  	add_column :rails_push_notifications_mpns_apps, :app_type, :string, default: 'end_user'
  end
end
