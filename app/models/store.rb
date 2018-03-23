class Store < ActiveRecord::Base
  require 'core_base/object'
  include Distanceable
  include Packable
  include ActionView::Helpers::TextHelper

	default_scope { order('stores.created_at DESC') }

  Cities = ["Ahmedabad","Gandhinagar"]

  geocoded_by :address

	validates :name, presence: true, length: { maximum: 50 }
	# validates_format_of :email, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  
  belongs_to :user
  belongs_to :store_category
  belongs_to :manageable, polymorphic: true
  has_many :deals, dependent: :destroy
  has_many :feeds, dependent: :destroy
  has_one :quotum, dependent: :destroy
  has_many :premium_notifications, dependent: :destroy
  has_many :deal_analytics, through: :deals, dependent: :destroy
  has_many :premium_notification_analytics, through: :premium_notifications, dependent: :destroy
  
  has_many :end_user_favourite_stores, dependent: :destroy
  has_many :favourite_end_users, through: :end_user_favourite_stores

  has_many :end_user_follow_stores, dependent: :destroy
  has_many :follow_end_users, through: :end_user_follow_stores 
  has_many :end_user_store_ref_codes
  has_many :outlets, dependent: :destroy
  has_many :merchant_users, as: :merchantable, dependent: :destroy

  has_one :sales_user_store, as: :creatable
  has_one :sales_user, through: :sales_user_store
  belongs_to :current_city, class_name: "City", foreign_key: "city_id"

  accepts_nested_attributes_for :user
  has_many :cashbacks
  has_attached_file :logo,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  has_attached_file :lmd_default_image,
                    styles: { :medium => "300x300>", :thumb => "100x100>" },
                    default_url: "/images/default/missing.png"

  validates_attachment_content_type :logo, :lmd_default_image,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'

  validates_with AttachmentSizeValidator, 
    :attributes => :logo, 
    :less_than => 50.kilobytes

  validates_with AttachmentSizeValidator,
                 :attributes => [:lmd_default_image],
                 :less_than => 300.kilobytes

  validate :logo_dimensions_validation
  validate :lmd_default_image_dimensions_validation


  after_create :create_quotum, :update_referral_code
  # before_create :set_expiry_date
  # before_save :set_expiry_date

  scope :by_type, lambda { |type| joins("LEFT JOIN #{type.table_name} 
    ON ((#{type.table_name}.id = stores.manageable_id AND stores.manageable_type = '#{type.to_s}'))") }
  scope :by_type_allowed, lambda { |type| by_type(type).where("stores.manageable_type is null OR 
    (#{type.table_name}.status is true AND (DATE(#{type.table_name}.expiry_date) >= ? or #{type.table_name}.expiry_date is null))",
    Time.zone.now.utc.to_date) }
  scope :allowed_manageable_stores, -> { by_type_allowed(Mall) }

  scope :enabled, -> { where(arel_table[:status].eq true) }
  scope :disabled, -> { where(arel_table[:status].eq false) }
  scope :with_store_city, -> (city) { where(arel_table[:city_id].eq city.to_i) if city.present? }
  
  scope :expired_in, -> (day = 0, require_upper = true) {
    conditions = arel_table[:expiry_date].gteq(Time.zone.now.utc.to_date)
    conditions = conditions.and(arel_table[:expiry_date].lteq(Time.zone.now.utc.to_date + day.days)) if require_upper
    where(conditions)
  }
  
  scope :with_unexpired_store, ->(day = 0, require_nil = true) {
    conditions = arel_table[:expiry_date].gteq(Time.zone.now.utc.to_date + day.days)
    conditions = conditions.or(arel_table[:expiry_date].eq(nil)) if require_nil
    where(conditions)
  }
  scope :allowed_stores, -> (city = nil) { enabled.with_store_city(city).allowed_manageable_stores.with_unexpired_store }
  scope :click_notify_allowed_stores, -> (city = nil) { allowed_stores(city) }
  scope :brand_only_store, -> (city = nil) { allowed_stores(city).where(is_brand_store: true) }
  
  scope :have_deal_click_quota, -> {}
  scope :have_premium_notification_quota, -> { 
    joins(:quotum).where('quota.premium_notification_used < quota.premium_notification_total') 
  }

  scope :with_outlets, ->  { joins(:outlets) }
  scope :with_any_outlets, ->  { joins('LEFT JOIN outlets ON outlets.store_id = stores.id') }
  scope :without_outlets, ->  { with_any_outlets.where('outlets.id is null') }
  def allowed?
    Store.allowed_stores.include?(self)
  end

  def store_photo
    logo.url if logo.present?
  end

  def lmd_default_photo
    lmd_default_image.url if lmd_default_image.present?
  end

  def local_name
      outlet_name = " - #{pluralize(outlets.outlet_status.length, 'Outlet')}" if outlets.present?
      "#{name}#{outlet_name}"
  end

  def no_of_deals(deal_types = [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd], Deal::DealType[:ced], Deal::DealType[:cedb]])
    deals.click_notify_allowed_deals(nil, deal_types).to_a.count
  end

  def has_mall?
    manageable.is_a?(Mall)
  end

  def mall_name
    manageable.name  if has_mall?
  end

  def reset_expiry_date
    update_attribute(:expiry_date, nil)
  end
  # ---------- Methods for Outlet 
  def has_outlets?
   outlets.outlet_status.present?
  end

  def sorted_outlet_steps(deal, lat, lng)
    if (outlet = nearest_outlet(deal, lat, lng)).present?
      outlet.outlet_steps
    else
      steps(lat,lng)
    end
  end

  def nearest_outlet(deal, lat, lng)
    deal.outlets.each { |o| o.outlet_steps = o.steps(lat, lng) }.sort_floating(:outlet_steps).first
  end
  # ---------- Methods for Outlet 

  def approved_deals
    deals.approved_deals
  end

  def unapproved_deals
    deals.unapproved_deals
  end

  def store_deals(_type, deal_types = [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd], Deal::DealType[:ced], Deal::DealType[:cedb],  Deal::DealType[:lmd]])
    if _type == "upcoming"
      deals.click_notify_allowed_deals(nil, deal_types).created_month_ago(2)
    else
      deals.click_notify_allowed_deals(nil, deal_types)
    end
  end

  def item_type_and_count
    item_type = "Deal"
    item_count = 0
    if has_outlets?
      item_type = "Outlet"
      item_count = outlets.outlet_status.count
    elsif store_deals("current").present?
      item_type = "Deal"
      item_count = store_deals("current").count
    elsif feeds.present?
      item_type = "Feed"
      item_count = feeds.count
    end
    return {item_type: item_type, item_count: item_count}
  end

  def share_text_url
    encrypt = self.id + 1350
    s_link = " - #{Settings.api.v1.share_url}/s/#{encrypt}"
    s_name = self.name
    s_address = self.address.present? ? " - #{self.address}" : ''
    "Find this store on #{Settings.app_name} | #{s_name}#{s_address}#{s_link}"
  end

  private 

  def create_quotum
    self.quotum = Quotum.create!(total: 0, premium_notification_total: 0, used: 0, premium_notification_used: 0)
  end

  def update_referral_code
    name = self.name.present? ? self.name[0..1].upcase : "AD"
    randstr = SecureRandom.hex(2).upcase
    coupon_code = name + randstr
    self.update_attribute('referral_code',coupon_code)
  end  

  # def set_expiry_date
  #   if self.created_at.present?
  #     self.expiry_date = (duration.present? and duration != 0) ? (self.created_at + duration.try(:day)) : nil
  #   end 
  # end

  def logo_dimensions_validation
    if logo.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(logo.queued_for_write[:original].path) 
      if dimensions.width > 200 && dimensions.height > 200
        errors.add(:logo,'width and height must be in 200x200')
      end
    end  
  end

  def lmd_default_image_dimensions_validation
    if lmd_default_image.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(lmd_default_image.queued_for_write[:original].path)
      if dimensions.width > 1024 && dimensions.height > 500
        errors.add(:lmd_default_image,'width and height must be in 1024x500')
      end
    end
  end
end
