class RequestedNotification < ActiveRecord::Base
  include AASM

  GENDER = {'0' => :male, '1' => :female, '2' => :both}

  belongs_to :merchantable, polymorphic: true
  belongs_to :merchant_user
  belongs_to :deal
  belongs_to :approver, class_name: "User", foreign_key: "approved_by"
  belongs_to :rejecter, class_name: "User", foreign_key: "rejected_by"
  belongs_to :deliverer, class_name: "User", foreign_key: "delivered_by"
  belongs_to :city
  belongs_to :target_deal_category, class_name: "DealCategory"

  has_many :pushed_notifications, as: :sendible, 
    class_name: 'RailsPushNotifications::Notification'    

  validates :target_device, inclusion: { in: ['all', 'google', 'apple'] }, allow_blank: true  
  validates :target_to, inclusion: { in: ['all', 'followers'] }, allow_blank: true  
  validates :notification_type, inclusion: { in: ['text', 'distance'] }, allow_blank: true
  validates :target_gender, inclusion: { in: RequestedNotification::GENDER.keys }, allow_blank: true
  validates :message, presence: true, length: { maximum: 150 }

  aasm do
  	state :pending, initial: true
  	state :approved
  	state :rejected
  	state :delivered

  	event :approve, before: :set_for_approve do
      transitions from: :pending, to: :approved
    end

    event :reject, before: :set_for_reject do
      transitions from: [:pending, :approved], to: :rejected
    end

    event :deliver, before: :set_for_deliver do
      transitions from: [:approved], to: :delivered, after: :send_push_notification
    end
  end

  def global_merchantable
    self.merchantable.to_global_id if self.merchantable.present?
  end

  def global_merchantable=(merchant)
    self.merchantable = GlobalID::Locator.locate merchant
  end

  def set_for_approve(end_user)
  	self.approved_at = Time.zone.now
  	self.approver = respondable_user(end_user)
  end

  def set_for_reject(end_user, rejected_because_of = nil)
  	self.rejected_at = Time.zone.now
  	self.rejecter = respondable_user(end_user)
  	self.rejected_because_of = rejected_because_of
  end

  def set_for_deliver(end_user)
  	self.delivered_at = Time.zone.now
  	self.deliverer = respondable_user(end_user)
  end

  def send_push_notification
    filted_options = { app_type: target_device || 'all', target_to: target_to,
      gender: target_gender, target_city_id: city_id, 
      target_deal_category_id: target_deal_category_id,
      merchant_user: merchant_user,
      target_distance: target_distance }
    if target_is_age_limit
      filted_options[:age_from] = target_age_from
      filted_options[:age_to] = target_age_to   
    end
    options = {}

    begin
      if deal.present?
        options[:outlet_id] = merchantable.id if merchantable.is_a?(Outlet)
      end
      PushNotification::ToEndUser::SenderRequestedJob.perform_later(self, message, filted_options, options)
    rescue Exception => e
      self.message = "#{message} and error : #{e.message}"
      reject!
    end
  end

  private

  def respondable_user(end_user)
    end_user || User.find_by(role: User::Roles[:super_admin])
  end  
end
