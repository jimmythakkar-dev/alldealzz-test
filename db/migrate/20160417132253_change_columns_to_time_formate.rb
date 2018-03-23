class ChangeColumnsToTimeFormate < ActiveRecord::Migration
  def up
  	remove_column :deals, :notification_time_from
  	remove_column :deals, :notification_time_to
  	add_column :deals, :notification_time_from, :time, default: "00:00:00"
  	add_column :deals, :notification_time_to, :time, default: "23:59:59"

    remove_column :premium_notifications, :notification_time_from
  	remove_column :premium_notifications, :notification_time_to
  	add_column :premium_notifications, :notification_time_from, :time, default: "00:00:00"
  	add_column :premium_notifications, :notification_time_to, :time, default: "23:59:59"
  end

  def down
  end
end
