class CreateEndUserPremiumNotifications < ActiveRecord::Migration
  def change
    create_table :end_user_premium_notifications do |t|
      t.integer :end_user_id
      t.integer :premium_notification_id
      t.boolean :aday, default: true
      t.integer :count, default: 0

      t.timestamps null: false
    end
  end
end
