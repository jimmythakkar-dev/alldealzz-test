class PremiumNotification < ActiveRecord::Base
  include Distanceable

  Days = {0 => :sun, 1 => :mon, 2 => :tue, 3 => :wed, 
    4 => :thu, 5 => :fri, 6 => :sat}

  geocoded_by :address
    
	belongs_to :store
  has_one :quotum, through: :store
	belongs_to :deal_category
  has_many :premium_notification_analytics, dependent: :destroy

  has_many :end_user_premium_notifications
  has_many :end_users, through: :end_user_premium_notifications

  has_many :pushed_notifications, as: :sendible, 
    class_name: 'RailsPushNotifications::Notification'
 
	validates :notification_text, length: { maximum: 120 }
  validate :date_validation
  before_save :set_publish_date
  before_save :set_expiry_date
  after_save :set_uniq_status

  scope :by_type, lambda { |type| includes(:store).joins("LEFT JOIN #{type.table_name} ON ((#{type.table_name}.id = stores.manageable_id AND stores.manageable_type = '#{type.to_s}') OR (stores.manageable_type is null))").group("premium_notifications.id") }
  scope :by_type_allowed, lambda { |type| by_type(type).where("stores.manageable_type is null OR (#{type.table_name}.status is true AND (DATE(#{type.table_name}.expiry_date) >= ? or #{type.table_name}.expiry_date is null))", 
    Time.zone.now.utc.to_date) }
  scope :allowed_manageable_stores, -> { by_type_allowed(Mall) }

  scope :enabled, -> { includes(:store).where('stores.status = true and premium_notifications.status = true') }
  scope :have_premium_notification_quota, -> { 
    joins(:quotum).where('quota.premium_notification_used < quota.premium_notification_total') 
  }

  # scope :allowed_pns, -> { enabled.where('(DATE(stores.expiry_date) >= ? or stores.expiry_date is null) and DATE(premium_notifications.publish_date) <= ? and (DATE(premium_notifications.expiry_date) >= ? or premium_notifications.expiry_date is null)', Date.today, Date.today, Date.today) }
  scope :allowed_pns, -> { enabled.allowed_manageable_stores.where('(DATE(stores.expiry_date) >= ? or stores.expiry_date is null) and DATE(premium_notifications.publish_date) <= ? and (DATE(premium_notifications.expiry_date) >= ? or premium_notifications.expiry_date is null)', 
    Time.zone.now.utc.to_date, Time.zone.now.utc.to_date, Time.zone.now.utc.to_date) }
  scope :notify_allowed_pns, -> { allowed_pns.have_premium_notification_quota }

  scope :interested_pns, ->(categories = []) {
    where('deal_category_id in (?)', categories) if categories
  }

  scope :in_notification_time, -> { where(' ? BETWEEN notification_time_from::time and notification_time_to::time', 
    Time.zone.now.strftime("%H:%M:%S")) }
  scope :at_days, -> { where('days like ? ', "%#{Time.zone.now.wday}%") }

  def days_text
    days.present? ? days.split(',').map {|i| Days[i.to_i].capitalize}.join(', ') : ""
  end

  def increse_quota
    if quotum.present? && 
      quotum.premium_notification_used < quotum.premium_notification_total
      quotum.update_attribute(:used, quotum.premium_notification_used + 1)
    end  
  end

  def create_notification_analytics(user)
    PremiumNotification.transaction do
      premium_notification_analytics.create(user: user)
    end
  end

  def toggle_status
    update_attribute(:status, !status)
  end

  def allowed?
    PremiumNotification.notify_allowed_pns.include?(self)
  end

  # ---------- Methods for Notification
  def send_push_notification(token, latitude, longitude)
    to_notify = {
      deal_id: nil,
      store_name: store.name,
      steps: steps(latitude, longitude),
      outlet_id: nil,
      feature_image: nil,
      text: notification_text, sender: self
    }
    token.send_push_notification(to_notify) 
  end
  # ---------- Methods for Notification
  
  private
  def set_publish_date
    self.publish_date = Time.zone.now if publish.present?
  end

  def set_expiry_date
    self.expiry_date = (duration.present? and duration != 0) ? (publish_date + duration.try(:day)) : nil
  end

  def date_validation
    if notification_time_from.present? &&  
        notification_time_to.present? && 
        notification_time_from > notification_time_to
      errors.add(:notification_time_to, "must be less then notification time from.")
    end
  end

  def set_uniq_status
    if self.status
      PremiumNotification.where('id != ? and store_id = ?', self.id, self.store.id).update_all({status: false})
    end  
  end
end
