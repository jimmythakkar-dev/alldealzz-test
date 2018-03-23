class AddNotificationTypeToEndUsers < ActiveRecord::Migration
  def change
    add_column :end_users, :notification_type, :boolean, default: false
  end
end
