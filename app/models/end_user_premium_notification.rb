class EndUserPremiumNotification < ActiveRecord::Base
	NotifyCount = 2

	belongs_to :end_user
  belongs_to :premium_notification

  validates :end_user_id, uniqueness: {scope: :premium_notification_id}

  def notifiable_premium_notification?
  	return false if self.aday.blank?
  	self.count = self.count + 1
  	self.aday = false if self.count >= NotifyCount
  	self.save! ? !self.aday : false
  end
end
