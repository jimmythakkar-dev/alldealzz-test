class FeedAnalytic < ActiveRecord::Base
  belongs_to :feed
  belongs_to :user, class_name: "EndUser"

  Flag = { click: 0, notification: 1}
  scope :by_flag, ->(flag_type) { where(flag: FeedAnalytic::Flag[flag_type])}
  
  scope :clicks, ->(store) {
    joins(:feed).where('feeds.store_id = ?', store).by_flag(:click) 
  }
  scope :notifications, ->(store) {
    joins(:feed).where('feeds.store_id = ?', store).by_flag(:notification) 
  }

  scope :last_week, -> {
    where("feed_analytics.created_at BETWEEN :start_date AND :end_date", {:start_date => 1.week.ago.in_time_zone, :end_date => 1.day.ago.in_time_zone })
  }

  scope :daily, -> {
    where("DATE(feed_analytics.created_at) = :today_date", {:today_date => Time.zone.now.utc.to_date })
  }

  scope :weekly, -> {
    where("feed_analytics.created_at >= :start_date", {:start_date => 1.week.ago.in_time_zone })
  }

  scope :monthly, -> {
    where("extract(month from feed_analytics.created_at) = :month", {:month => Time.zone.now.utc.month })
  }

  scope :yearly, -> {
    where("extract(year from feed_analytics.created_at) = :year", {:year => Time.zone.now.utc.year })
  }
  
end
