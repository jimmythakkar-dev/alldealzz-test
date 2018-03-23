class CreatePremiumNotificationAnalytics < ActiveRecord::Migration
  def change
    create_table :premium_notification_analytics do |t|
      t.integer :premium_notification_id
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
