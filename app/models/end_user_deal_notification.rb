class EndUserDealNotification < ActiveRecord::Base

  NotifyCount = 2

	belongs_to :end_user
  belongs_to :deal

  belongs_to :deal_notification, 
    class_name: "Deal", foreign_key: "deal_id"
  belongs_to :end_user_notification, 
    class_name: "EndUser", foreign_key: "end_user_id"

  validates :end_user_id, uniqueness: {scope: :deal_id}

  # If aday is blank then deal is not notifiable,
  # it means,  `count` exeds `notify_count` limit, then aday becomes false
  # so deal is not notifiable now onwards...
  def notifiable_deal?(notify_count = NotifyCount)
  	return false if self.aday.blank?
  	self.count = self.count + 1
  	self.aday = false if self.count >= notify_count
  	self.save! ? !self.aday : false
  end
end
