class EndUser < ActiveRecord::Base
  LOGIN_TYPE = {
    0 => :email,
    1 => :facebook_uid,
    2 => :google_uid,
    3 => :phone_number
  }

  DEVICE_TYPE = {
    1 => :google,
    0 => :apple
  }

  has_many :end_user_favourites, dependent: :destroy
  has_many :favourite_deals, through: :end_user_favourites
  
  has_many :end_user_favourite_stores, dependent: :destroy
  has_many :favourite_stores, through: :end_user_favourite_stores

  has_many :end_user_used_deals, dependent: :destroy
  has_many :used_deals, -> { where.not end_user_used_deals: { booking_code_id: nil } }, through: :end_user_used_deals
  has_many :transaction_details, through: :end_user_used_deals
  has_many :transaction_detail_deals, through: :transaction_details, source: :deal

  has_many :end_user_follow_stores, dependent: :destroy
  has_many :follow_stores, through: :end_user_follow_stores

  has_many :end_user_follow_malls, dependent: :destroy
  has_many :follow_malls, through: :end_user_follow_malls  

  has_many :end_user_categories, dependent: :destroy 
  has_many :deal_categories, through: :end_user_categories

  has_many :end_user_deal_reviews, dependent: :destroy
  has_many :deal_reviews, through: :end_user_deal_reviews

  has_many :end_user_feedbacks, dependent: :destroy
  
  has_many :end_user_deal_notifications
  has_many :deal_notifications, through: :end_user_deal_notifications

  has_many :end_user_premium_notifications
  has_many :premium_notifications, through: :end_user_premium_notifications

  has_many :end_user_subscribed_cities, dependent: :destroy
  has_many :end_user_applied_codes, dependent: :destroy

  has_many :end_user_feed_favourites, dependent: :destroy
  has_many :favourite_feeds, through: :end_user_feed_favourites

  has_many :end_user_feed_reviews, dependent: :destroy
  has_many :feed_reviews, through: :end_user_feed_reviews

  has_many :end_user_feed_reminders, dependent: :destroy
  has_many :feed_reminders, through: :end_user_feed_reminders

  has_many :end_user_deal_reminders, dependent: :destroy
  has_many :deal_reminders, through: :end_user_feed_reminders

  has_one :end_user_store_ref_code
  has_one :membership_transaction_detail
  has_many :end_user_points_histories
  belongs_to :city
  belongs_to :voucher_code_detail
  belongs_to :club_membership_detail
  has_one :end_user_reward_point
  # Not used
  has_many :oauth_access_tokens, -> { where(resource_owner_type: "EndUser") }, 
    class_name: "Doorkeeper::AccessToken",
    foreign_key: :resource_owner_id

  has_secure_password validations: false
  with_options if: :validatable_pwd? do |pwd|
    pwd.validates :password, confirmation: true, presence: true
    pwd.validates :password_confirmation, presence: true
  end

  validates :email, allow_nil: true, uniqueness: true
  # validates :email, presence: true, if: "facebook_uid.blank? && google_uid.blank?"
  validates :facebook_uid, allow_nil: true, uniqueness: true
  # validates :facebook_uid, presence: true, if: "email.blank? && google_uid.blank?"
  validates :google_uid, allow_nil: true, uniqueness: true
  # validates :google_uid, presence: true, if: "facebook_uid.blank? && email.blank?"
  validates :phone_number, allow_nil: true, uniqueness: true
  # validates :phone_number, presence: true, if: "facebook_uid.blank? && email.blank? && google_uid.blank?"

  validates :gender, inclusion: { 
    in: ['male', 'female'], 
    message: "is male or female" }, if: "gender.present?"
  validates :age, numericality: true, if: "age.present?"

  # scope :enabled_for_notification, -> { where(notification_status: true) }
  after_create :update_end_user_reward_point
  
  has_attached_file :photo,
    styles: { :medium => "300x300>", :thumb => "100x100>" }

  validates_attachment_content_type :photo,
    content_type: /\Aimage\/.*\Z/
  validates_with AttachmentSizeValidator, 
    :attributes => [:photo], 
    :less_than => 10.megabytes
  def profile_photo
    if photo.present?
    	photo.url
	  elsif photo_url.present?
	    photo_url
	  end	
  end

  def update_end_user_reward_point
    user_id = self.id
    end_user_reward_points = EndUserRewardPoint.find_or_create_by(end_user_id: user_id, points: 50)
    end_user_reward_points.save
  end
  def present_email?
    email.present?
  end
  
  # NOTE  : Same in SalesUser, MerchantUser, EndUser. 
  #         Because used in RailsPushNotifications#resource_owners
  def profile_name
    name || email
  end  
   
  #-----------
  def self.authenticate(femail, fpassword)
    return if femail.blank? || fpassword.blank?
    find_with_login_type(0, femail).try(:authenticate, fpassword)
  end

  def self.find_with_login_type(login_type, val)
    login_type = 0 if EndUser::LOGIN_TYPE.keys.exclude?(login_type)
    find_by(EndUser::LOGIN_TYPE[login_type] => val)
  end

  def self.create_with_login_type(login_type, val, pwd = nil)
    login_type = 0 if EndUser::LOGIN_TYPE.keys.exclude?(login_type)
    values = { EndUser::LOGIN_TYPE[login_type] => val }
    values.merge!(password: pwd, password_confirmation: pwd) if login_type == 0
    EndUser.create(values)
  end

  def self.find_with_phone_number(login_type, phone_number)
    find_by(EndUser::LOGIN_TYPE[login_type] => phone_number)
  end

  def self.create_with_phone_number(phone_number)
    login_type = 3
    values = { EndUser::LOGIN_TYPE[login_type] => phone_number }
    values.merge!(phone_verified: true)
    EndUser.create(values)
  end

  def self.find_or_create_with_login_type(login_type, val, pwd = nil)
    if val.present?
      find_with_login_type(login_type, val) || create_with_login_type(login_type, val, pwd)
    end  
  end
  #-----------

  #------Reset password-----------
  def send_reset_password
    transaction do
      generate_token(:reset_password_token)
      self.reset_password_sent_at = Time.zone.now
      save!
      EndUserMailer.reset_password(self).deliver
    end
  end

  def reset_password_is_expired?
    reset_password_sent_at < 2.hours.ago
  end
  
  attr_accessor :pwd_updated
  def reset_password(pwd, pwd_confirmation)
    update_attributes(password: pwd, password_confirmation: pwd_confirmation, 
      pwd_updated: true, reset_password_token: nil)
  end
  #-----------------

  def favourite_deal?(deal)
    favourite_deals.to_a.include?(deal)
  end

  def favourite_store?(store)
    favourite_stores.to_a.include?(store)
  end

  def favourite_feed?(feed)
    favourite_feeds.to_a.include?(feed)
  end


  def follow_mall?(mall)
    follow_malls.to_a.include?(mall)
  end

  def follow_store?(store)
    follow_stores.to_a.include?(store)
  end

  def deal_used?(deal)
    used_deals.to_a.include?(deal)
  end

  def deal_reviewed?(deal)
    deal_reviews.to_a.include?(deal)
  end

  def otp_status
    if !self.otp_verified? && !self.otp_requested?
     3
    elsif !self.otp_verified? && self.otp_requested?
     2
    else
     1
    end
  end

  def membership_days
    return -1 unless membership_expiry_date.present?
    days = (membership_expiry_date - Time.zone.now.to_date).to_i
    days
  end

  def is_club_member?
     membership_days >= 0
  end

  def feed_reminder(feed)
    reminder = end_user_feed_reminders.where(status: true, feed_id: feed.id).last
    if reminder.present?
       if  reminder.reminder_time.in_time_zone < Time.zone.now
         reminder.update_attributes(status: false)
         return []
       else
         return reminder
       end
    end
  end


  def deal_reminder(deal)
    reminder = end_user_deal_reminders.where(status: true, deal_id: deal.id).last
    if reminder.present?
      if  reminder.reminder_time.in_time_zone < Time.zone.now
        reminder.update_attributes(status: false)
        return []
      else
        return reminder
      end
    end
  end

  private

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while EndUser.exists?(column => self[column])
  end

  def validatable_pwd?
    pwd_updated.present? || (email.present? && (new_record? || password.present? || password_confirmation.present?))
  end
end
