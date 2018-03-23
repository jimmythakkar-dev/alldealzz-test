class DealAnalytic < ActiveRecord::Base
  belongs_to :deal
  belongs_to :user, class_name: "EndUser"

  Flag = { click: 0, notification: 1}
  scope :by_flag, ->(flag_type) { where(flag: DealAnalytic::Flag[flag_type])}
  
  scope :clicks, ->(store) {
    joins(:deal).where('deals.store_id = ?', store).by_flag(:click) 
  }
  scope :notifications, ->(store) {
    joins(:deal).where('deals.store_id = ?', store).by_flag(:notification) 
  }

  scope :last_week, -> {
    where("deal_analytics.created_at BETWEEN :start_date AND :end_date", {:start_date => 1.week.ago.in_time_zone, :end_date => 1.day.ago.in_time_zone })
  }

  scope :daily, -> {
    where("DATE(deal_analytics.created_at) = :today_date", {:today_date => Time.zone.now.utc.to_date })
  }

  scope :weekly, -> {
    where("deal_analytics.created_at >= :start_date", {:start_date => 1.week.ago.in_time_zone })
  }

  scope :monthly, -> {
    where("extract(month from deal_analytics.created_at) = :month", {:month => Time.zone.now.utc.month })
  }

  scope :yearly, -> {
    where("extract(year from deal_analytics.created_at) = :year", {:year => Time.zone.now.utc.year })
  }

  scope :male, -> {
    joins(:user).where(end_users: { gender: "male"}).pluck(:user_id).uniq
  }
  scope :female, -> {
    joins(:user).where(end_users: { gender: "female"}).pluck(:user_id).uniq
  }
  scope :not_specifed, -> {
    joins(:user).where(end_users: { gender: nil}).pluck(:user_id).uniq
  }
  scope :age_1, -> {
    joins(:user).where('end_users.age BETWEEN 17 AND 24').pluck(:user_id).uniq
  }
  scope :age_2, -> {
    joins(:user).where('end_users.age BETWEEN 24 AND 30').pluck(:user_id).uniq
  }
  scope :age_3, -> {
    joins(:user).where('end_users.age >= 30').pluck(:user_id).uniq
  }
  scope :age_4, -> {
    joins(:user).where('end_users.age is null').pluck(:user_id).uniq
  }

  scope :date_report, -> (from_date , end_date) {
    where("deal_analytics.created_at >= :from_date AND deal_analytics.created_at <= :end_date", { from_date: from_date , end_date: end_date})
  }
end
