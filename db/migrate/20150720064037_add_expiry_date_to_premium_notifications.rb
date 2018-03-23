class AddExpiryDateToPremiumNotifications < ActiveRecord::Migration
  def change
    add_column :premium_notifications, :expiry_date, :datetime
  end
end
