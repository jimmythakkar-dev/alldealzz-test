class AddColumnsAndRenameMerchantUserRequestedNotificationsToUserRequestedNotifications < ActiveRecord::Migration
  def up
  	rename_table :merchant_user_requested_notifications, :requested_notifications
    
    add_column :requested_notifications, :notification_type, :string
    add_column :requested_notifications, :merchantable_id, :integer
    add_column :requested_notifications, :merchantable_type, :string
    add_column :requested_notifications, :deal_id, :integer
    add_column :requested_notifications, :target_to, :string
    add_column :requested_notifications, :target_device, :string
    add_column :requested_notifications, :target_is_age_limit, :boolean, default: false
    add_column :requested_notifications, :target_age_from, :integer
    add_column :requested_notifications, :target_age_to, :integer
    add_column :requested_notifications, :target_gender, :string

    add_index :requested_notifications, [:merchantable_id, :merchantable_type], 
      name: :index_on_merchantable_id_and_merchantable_type
    
    RailsPushNotifications::Notification.where(sendible_type: "MerchantUserRequestedNotification")
      .find_in_batches(batch_size: 100).with_index do |group, batch|
      puts "Processing group ##{batch} : Adding sendible_type as RequestedNotification"
      group.each { |notification| notification.update_attribute(:sendible_type, "RequestedNotification") }
      sleep(10)
    end
  end

  def down
    remove_index :requested_notifications, name: :index_on_merchantable_id_and_merchantable_type

    remove_column :requested_notifications, :target_gender
    remove_column :requested_notifications, :target_age_to
    remove_column :requested_notifications, :target_age_from
    remove_column :requested_notifications, :target_is_age_limit
    remove_column :requested_notifications, :target_device
    remove_column :requested_notifications, :target_to
    remove_column :requested_notifications, :deal_id
    remove_column :requested_notifications, :merchantable_type
    remove_column :requested_notifications, :merchantable_id
    remove_column :requested_notifications, :notification_type

    rename_table :requested_notifications, :merchant_user_requested_notifications
  end
end
