class PremiumNotificationAnalytic < ActiveRecord::Base
  belongs_to :premium_notification
  belongs_to :user, class_name: "EndUser"

  scope :notifications, ->(store) {
    joins(:premium_notification).where('premium_notifications.store_id = ?', store) 
  }

  scope :daily, -> {
    where("DATE(premium_notification_analytics.created_at) = :today_date", {:today_date => Time.zone.now.utc.to_date })
  }

  scope :weekly, -> {
    where("premium_notification_analytics.created_at >= :start_date", {:start_date => 1.week.ago.in_time_zone })
  }

  scope :monthly, -> {
    where("extract(month from premium_notification_analytics.created_at) = :month", {:month => Time.zone.now.utc.month })
  }

  scope :yearly, -> {
    where("extract(year from premium_notification_analytics.created_at) = :year", {:year => Time.zone.now.utc.year })
  }
end
