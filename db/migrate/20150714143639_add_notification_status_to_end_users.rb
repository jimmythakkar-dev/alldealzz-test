class AddNotificationStatusToEndUsers < ActiveRecord::Migration
  def change
    add_column :end_users, :notification_status, :boolean, default: true
    add_column :end_users, :status, :boolean, default: true
  end
end
