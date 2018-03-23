class Deal < ActiveRecord::Base
  include Geocoder::Store::ActiveRecord

  # validates :main_line, presence: true, uniqueness: true
  GENDER = {0 => :male, 1 => :female, 2 => :both}
  Days = {0 => :sun, 1 => :mon, 2 => :tue, 3 => :wed, 
    4 => :thu, 5 => :fri, 6 => :sat}
  DealType = { rd: 0, lmd: 1, ed: 2, pd: 3, ced: 4, cedb: 5}
  
  belongs_to :store
  belongs_to :approver, class_name: "User", foreign_key: "approved_by"
  has_one :quotum, through: :store
  has_many :deal_deal_categories, dependent: :destroy
  has_many :deal_categories, through: :deal_deal_categories
  
  has_many :deal_newsletters, dependent: :destroy
  has_many :newsletters, through: :deal_newsletters

  has_many :deal_analytics, dependent: :destroy
  has_many :end_user_favourites, dependent: :destroy
  has_many :favourite_end_users, through: :end_user_favourites

  has_many :end_user_used_deals, dependent: :destroy
  has_many :used_end_users, through: :end_user_used_deals
  has_many :transaction_details, through: :end_user_used_deals

  has_many :end_user_deal_reviews, dependent: :destroy
  has_many :end_user_reviews, through: :end_user_deal_reviews

  has_many :end_user_deal_notifications
  has_many :end_user_notifications, through: :end_user_deal_notifications

  has_many :oauth_access_token_deal_notifications
  has_many :oauth_access_tokens, through: :oauth_access_token_deal_notifications

  has_many :pushed_notifications, as: :sendible, 
    class_name: 'RailsPushNotifications::Notification'

  has_many :deal_outlets, dependent: :destroy  
  has_many :outlets, through: :deal_outlets

  has_many :end_user_deal_reminders, dependent: :destroy
  has_many :end_user_reminders, through: :end_user_deal_reminders

  # has_many :geo_coordinates, through: :outlets
  has_many :deal_detail_images, dependent: :destroy
  has_many :cashbacks
  has_many :end_user_points_histories
  has_attached_file :main_image,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  has_attached_file :featured_image,
    styles: { :medium => "300x300>", :thumb => "100x100>" },
    default_url: "/images/default/missing.png"
  # validates_attachment :main_image,
  #   content_type: {content_type: /\Aimage\/.*\Z/},
  #   size: { less_than: 1.megabytes }

  validates_attachment_content_type :main_image, :featured_image,
    :content_type => /^image\/(png|jpeg|jpg)/,
    :message => 'only (png/jpg) images'

  # validates_with AttachmentSizeValidator,
  #   :attributes => [:main_image],
  #   :less_than => 150.kilobytes
  validates_with AttachmentSizeValidator,
    :attributes => [:featured_image],
    :less_than => 300.kilobytes

  # validate :main_image_dimensions_validation
  validate :featured_image_dimensions_validation
  validates :publish_date, presence: true
  validates :expiry_date, presence: true, if: :validation_condition
  validates :main_line, presence: true, length: { maximum: 80 }
  validates :description, length: { maximum: 3000 }
  validates :notification_text, length: { maximum: 120 }
  validates :sponsor_order, allow_nil: true, uniqueness: true

  attr_accessor  :steps
  attr_accessor :root_deal_category_id, :sub_deal_category_ids

  validate :date_validation
  before_save :set_publish_date
  # before_save :set_expiry_date
  
  
  attr_accessor :skip_before_save

  scope :with_stores, ->  { joins(:store) }
  scope :by_type, lambda { |type| with_stores.joins("LEFT JOIN #{type.table_name} 
    ON ((#{type.table_name}.id = stores.manageable_id AND stores.manageable_type = '#{type.to_s}'))") }
  scope :by_type_allowed, lambda { |type| by_type(type).where("stores.manageable_type is null OR 
    (#{type.table_name}.status is true AND (DATE(#{type.table_name}.expiry_date) >= ? or #{type.table_name}.expiry_date is null))", 
    Time.zone.now.utc.to_date) }
  scope :allowed_manageable_stores, -> { by_type_allowed(Mall) }

  scope :enabled, ->  { with_stores.where('stores.status = true and deals.status = true') }
  scope :disabled, ->  { with_stores.where('stores.status = false or deals.status = false') }
  scope :with_store_city, -> (city) { with_stores.where('stores.city_id = ?', city.to_i) if city.present? }
  scope :have_deal_click_quota, -> {}
  scope :with_unexpired_store, -> { with_stores.where('DATE(stores.expiry_date) >= ? or stores.expiry_date is null', 
    Time.zone.now.utc.to_date) }

  scope :expired_in, -> (day = 0, require_upper = true) {
    conditions = arel_table[:expiry_date].gteq(Time.zone.now.utc.to_date)
    conditions = conditions.and(arel_table[:expiry_date].lteq(Time.zone.now.utc.to_date + day.days)) if require_upper
    where(conditions)
  }
  scope :with_unexpired_deal, -> { where('DATE(deals.expiry_date) >= ? or deals.expiry_date is null', 
    Time.zone.now.utc.to_date) }
  scope :with_expired_deal, -> { where('DATE(deals.expiry_date) < ?', Time.zone.now.utc.to_date) }
  scope :with_deal_type, -> (lmd = DealType[:rd]) { where(deal_type: lmd) unless lmd.nil? }
  scope :without_deal_type, -> (lmd = DealType[:rd]) { where.not(deal_type: lmd) unless lmd.nil? }
  
  scope :approved_deals, -> { joins(:approver) }
  scope :unapproved_deals, -> { joins('LEFT JOIN users ON users.id = deals.approved_by').where('users.id is null') }
  scope :enabled_deals, -> (city = nil) { enabled.approved_deals.with_store_city(city).allowed_manageable_stores.with_unexpired_store.with_unexpired_deal }
  scope :allowed_deals, -> (city = nil) { enabled_deals(city).where('DATE(deals.publish_date) <= ?', Time.zone.now.utc.to_date) }
  scope :upcoming_deals, -> (city = nil) { enabled_deals(city).where('DATE(deals.publish_date) > ?', Time.zone.now.utc.to_date) }
  
  scope :click_notify_enabled_deals, -> (city = nil, lmd = nil) { with_deal_type(lmd).enabled_deals(city) }
  scope :click_notify_allowed_deals, -> (city = nil, lmd = nil) { with_deal_type(lmd).allowed_deals(city) }
  scope :click_notify_upcoming_deals, -> (city = nil, lmd = nil) { with_deal_type(lmd).upcoming_deals(city) }
  scope :sponsored_deals, -> { where('is_sponsored is true').order("sponsor_order ASC")}

  scope :nearest_deals, ->(lat, lng, distance = 2) {
    center_point = [lat, lng]
    if center_point.all?
      box = Geocoder::Calculations.bounding_box(center_point, distance)
      # kind of query used by 'within_bounding_box'(Geocoder)
      with_locations.where('geo_coordinates.latitude BETWEEN ? AND ? AND geo_coordinates.longitude BETWEEN ? AND ?',box[0],box[2],box[1],box[3]).group('deals.id')
    end
  }

  scope :with_outlets, ->  { joins(:outlets) }
  scope :with_any_outlets, ->  { joins('LEFT JOIN deal_outlets ON deal_outlets.deal_id = deals.id
      LEFT JOIN outlets ON outlets.id = deal_outlets.outlet_id') }
  scope :without_outlets, ->  { with_any_outlets.where('outlets.id is null') }

  scope :with_locations, -> { 
    with_any_outlets.joins("
      INNER JOIN geo_coordinates 
      ON (outlets.id is not null AND geo_coordinates.locationable_id = outlets.id AND geo_coordinates.locationable_type = 'Outlet') 
      OR (outlets.id is null AND geo_coordinates.locationable_id = stores.id AND geo_coordinates.locationable_type = 'Store') 
      ").where("geo_coordinates.id is not null") }

  # Required geo_coordinates
  scope :nearest, -> (lat, lng) {
    select("deals.*, MIN(3958.755864232 * 2 * ASIN(SQRT(POWER(SIN((#{lat} - geo_coordinates.latitude) * PI() / 180 / 2), 2) + COS(#{lat} * PI() / 180) * 
        COS(geo_coordinates.latitude * PI() / 180) * POWER(SIN((#{lng} - geo_coordinates.longitude) * PI() / 180 / 2), 2)))) AS distance").
      group('deals.id').order('distance')
  }  

  # Refer https://github.com/alexreisner/geocoder/blob/e9d7100009ff7be15a9d5a3e7578ceee0e047bb4/lib/geocoder/stores/active_record.rb
  # scope :near
  # Required geo_coordinates
  scope :near_deals, -> (lat, lng, distance = 10000) {
    near([lat, lng], distance, order: 'distance', 
      latitude: 'geo_coordinates.latitude', longitude: 'geo_coordinates.longitude')
    }

  scope :created_month_ago, -> (months = 1) { where('deals.created_at >= ?', months.month.ago) }

  scope :popular_deals, -> {
    select('deals.*,  AVG(end_user_deal_reviews.rating) as pl').joins(:end_user_deal_reviews).group('deals.id').having('AVG(end_user_deal_reviews.rating) > 0').order("pl DESC")
  }

  scope :best_seller_deals, -> {
    select('deals.*, COUNT(deals.id) as bs').joins(:end_user_used_deals).where("end_user_used_deals.booking_code_id is not null").group('deals.id').order("bs DESC")
  }

  scope :redeemed_deals, -> {
    joins(:end_user_used_deals).where('end_user_used_deals.used_status is true').group('deals.id')
  }

  scope :unredeemed_deals, -> {
    joins(:end_user_used_deals).where('end_user_used_deals.used_status is false').group('deals.id')
  }

  scope :with_success_full_payment, -> {
    joins(:transaction_details).where('transaction_details.payment_status = ?', 
      TransactionDetail::PaymentStatus[:success]).group('deals.id')
  }

  scope :view_count_deals, -> {
    select('deals.*, COUNT(deals.id) as vc').joins(:deal_analytics).where('deal_analytics.flag = 0').group('deals.id').order("vc DESC")
  }

  scope :age_deals, ->(age = nil) {
    where('(? BETWEEN age_from AND age_to AND is_age_limit is true) or (is_age_limit is false) or (is_age_limit is null)', age) if age.present?
  }

  scope :gender_deals, ->(gender = nil) {
    where('(gender in (?)) or (gender is null)', [gender.to_s, "2"]) if gender.present?
  }

  scope :age_gender_deals, ->(age, gender) {
    age_deals(age).gender_deals(gender)
  }

  scope :interested_deals, ->(categories = []) {
    joins(:deal_categories).where('deal_categories.id in (?)', categories) if categories
  }

  scope :in_notification_time, -> { where(' ? BETWEEN notification_time_from::time and notification_time_to::time', Time.zone.now.strftime("%H:%M:%S")) }
  scope :in_last_minute_deal_time, -> { where('? >= last_start_time::time and ? <= last_end_time::time', Time.zone.now.strftime("%H:%M:%S"), Time.zone.now.strftime("%H:%M:%S") ) }

  scope :at_days, -> { where('days like ? ', "%#{Time.zone.now.wday}%") }

  scope :live_again_deals, -> { where('deals.expiry_date > ?', Time.zone.now.utc) }
  
  scope :days_valid, -> {where('days is not null')}

  scope :in_last_deal_time, -> { live_again_deals.where.not('? >= last_start_time::time and ? <= last_end_time::time', Time.zone.now.strftime("%H:%M:%S"), Time.zone.now.strftime("%H:%M:%S") ) }

  def validation_condition
    if expiry_date.present? && expiry_date < publish_date
      errors.add(:expiry_date, "can't be in the past")
    end
  end

  def gender_text
    gender.present? ? GENDER[gender.to_i] : ""
  end

  def days_text
    days.present? ? days.split(',').map {|i| Days[i.to_i].capitalize}.join(', ') : ""
  end

  def is_user_like
    true
  end  

  def title
    main_line
  end  
  
  def deal_photo
    featured_image(:medium) if featured_image.present?
  end 

  def featured_photo
    featured_image.url if featured_image.present?
  end

  def sponsored_deal_photo
    main_image.url if main_image.present?
  end

  def lmd_photo
    store.lmd_default_photo
  end

  def store_photo
    store.store_photo
  end
  
  def cashback_discount
    begin
      deal_c = self.cashbacks.allowed_cashbacks.map(&:discount)
      store_c = self.store.cashbacks.store_cashbacks.map(&:discount)
      categories_c = self.deal_categories.root_categories.first.cashbacks.deal_category_cashbacks.map(&:discount)
      [deal_c, store_c, categories_c].compact.flatten.max
    rescue
      false
    end
  end
  
  def toggle_status
    update_attribute(:status, !status)
  end

  def deals(*_ids)
    [].push(self)
  end

  def create_click_analytics(user)
		DealAnalytic.transaction do
      deal_analytics.create(user: user, flag: DealAnalytic::Flag[:click])
    end
  end

  def increse_quota
    if quotum.present? && quotum.used < quotum.total
      quotum.update_attribute(:used, quotum.used + 1)
    end  
  end

  # TODO for notification
  # Changed user to user.id because of :
  # ActiveRecord::AssociationTypeMismatch (EndUser(#70248711858380) expected, got EndUser(#70248689990620)):
  #                                           app/models/deal.rb:177:in `block in create_notification_analytics'
  # app/models/deal.rb:176:in `create_notification_analytics'
  # config/initializers/rails_push_notification.rb:51:in `create_notification_analytics'
  # app/models/end_user.rb:265:in `send_notification'
  # app/models/end_user.rb:165:in `send_push_notification'
  # app/jobs/store_notification_job.rb:42:in `perform'
  # app/controllers/api/v2/local/base_controller.rb:22:in `notify_store'

  def create_notification_analytics(user)
		DealAnalytic.transaction do
      deal_analytics.create(user_id: user.id, flag: DealAnalytic::Flag[:notification])
    end
  end  

  def share_text_url
    encrypt = self.id + 1000
    s_link = " - #{Settings.api.v1.share_url}/d/#{encrypt}"
    s_name = self.store.name
    s_address = self.store.address.present? ? " - #{self.store.address}" : ''
    "Find this offer on #{Settings.app_name} | #{main_line} - #{s_name} #{s_link}"
  end

  def allowed?
    Deal.click_notify_allowed_deals.include?(self)
  end

  def package_days
    return 0 unless expiry_date.present?
    days = (expiry_date.to_date - Time.zone.now.to_date).to_i
    days <= 0 ? 0 : days
  end

  def expired?
    if is_last_minute_deal? 
      if package_days > 0 
        !(Time.zone.now.try(:strftime, "%H:%M:%S").between?(last_start_time.try(:strftime, "%H:%M:%S"), last_end_time.try(:strftime, "%H:%M:%S")))
      else package_days <= 0
        !package_days.nil? && package_days <= 0 
      end
    else 
      !package_days.nil? && package_days <= 0 
    end
  end 

  def reviews(first_limit = nil)
    end_user_deal_reviews.includes(:end_user).order('end_user_deal_reviews.created_at desc').limit(first_limit)
  end

  #---------deal type--------------------
  def is_deal_type?(test_type = DealType[:rd])
    deal_type == test_type
  end

  def is_regular_deal?
    is_deal_type?
  end

  def is_last_minute_deal?
    is_deal_type?(DealType[:lmd])
  end

  def is_exclusive_deal?
    is_deal_type?(DealType[:ed])
  end

  def is_paid_deal?
    is_deal_type?(DealType[:pd])
  end

  def is_club_exclusive_paid?
    is_deal_type?(DealType[:ced])
  end

  def is_club_exclusive_book?
    is_deal_type?(DealType[:cedb])
  end

  def deal_type_to_s
    case deal_type
      when DealType[:rd]
        "regular"
      when DealType[:lmd]
        "last_minute"
      when DealType[:ed]
        "exclusive"
      when DealType[:pd]
        "paid"
      when DealType[:ced]
        "club_exclusive"
      when DealType[:cedb]
        "club_exclusive_book"
    end
  end
  #---------deal type--------------------

  # ------- category -------------
  def deal_root_categories
    if is_last_minute_deal?
      DealCategory.last_deal_root_categories
    else  
      DealCategory.deal_root_categories
    end
  end

  def root_deal_category_id
    root_deal_category.try(:id)
  end

  def root_deal_category
    if is_last_minute_deal?
      deal_categories.last_deal_root_categories.first
    else  
      deal_categories.deal_root_categories.first
    end  
  end

  def sub_deal_category_ids
    sub_deal_categories.map(&:id)
  end

  def sub_deal_categories
    if is_last_minute_deal?
      deal_categories.last_deal_sub_categories
    else  
      deal_categories.deal_sub_categories
    end
  end
  # ------- category -------------

  # return time of last_start_time & last_end_time is in utc 
  # because it store as time not in datetime
  
  def live_time_difference
    current_time, deal_start_time = expire_lmd_parse_times

    required_day = nil
    valid_days = days.split(',')
    current_day = current_time
    
    (1..7).each do
      unless required_day
        if valid_days.include?(current_day.wday.to_s) && ((current_day.wday != current_time.wday) || (current_day.wday == current_time.wday) &&  (current_time < deal_start_time))
          required_day = current_day.wday
          break
        else  
          current_day = current_day + 1.day
        end  
      end
    end

    day = Date::DAYNAMES[required_day]
    
    date  = Date.parse(day)
    delta = (date >= Date.today && (current_time < Time.zone.parse(date.to_s + " " + deal_start_time.to_s))) ? 0 : 7
    valid_date = date + delta
    deal_start_time  = last_start_time.try(:strftime, "%H:%M:%S")
    
    next_start_time = Time.zone.parse(valid_date.to_s + " " + 
      deal_start_time)
    total_time = ((next_start_time - current_time)/60).to_i
  end

  def expire_lmd_parse_times(floor_count = 1)
    current_time = last_start_time.present? ? Time.zone.now.try(:strftime, "%H:%M:%S") : "00:00:00"
    deal_start_time = last_start_time.try(:strftime, "%H:%M:%S") || "00:00:00"
    [Time.zone.parse(current_time).floor(floor_count), Time.zone.parse(deal_start_time).ceiling(floor_count)]
  end

  def lmd_time_difference
    t_start, t_end = lmd_parse_times
    total_seconds = t_end - t_start
    Time.at(total_seconds >= 0 ? total_seconds : 0).utc
  end

  def lmd_time_slots
    t_start, t_end = lmd_parse_times(30.minutes)
    (t_start.to_i .. t_end.to_i).step(30.minutes).map { |date| Time.zone.at(date) }
  end

  def lmd_parse_times(floor_count = 1)
    t_start = last_end_time.present? ? Time.zone.now.try(:strftime, "%H:%M:%S") : "00:00:00"
    t_end = last_end_time.try(:strftime, "%H:%M:%S") || "00:00:00"
    [Time.zone.parse(t_start).floor(floor_count), Time.zone.parse(t_end).ceiling(floor_count)]
  end

  # ---------- Methods for Notification
  def send_push_notification(token, latitude, longitude)
    to_notify = {
      deal_id: id,
      store_name: store.name,
      steps: store.sorted_outlet_steps(self, latitude, longitude),
      outlet_id: store.nearest_outlet(self, latitude, longitude).try(:id),
      feature_image: featured_photo,
      deal_type: deal_type,
      type: 0, text: notification_text, sender: self
    }
    token.send_push_notification(to_notify) 
  end
  # ---------- Methods for Notification

  # is_with : true/false
  def save_as_approval(is_with)
    self.status = is_with.present?

    user = if is_with.present?
      User.find_by(role: User::Roles[:super_admin])
    end  
    self.approver = user

    save
  end
  
  # is_with : true/false, deal_params : deal params as hash
  def update_as_approval(is_with, deal_params)
    self.status = is_with.present?
    self.approver = nil unless is_with.present?
    update(deal_params)
  end

  def approved?
    approver.present?
  end

  def toggle_approver(user)
    user = approved? ? nil : user
    update_attribute(:approver, user)
  end

  def has_price?
    price.present? && discounted_price.present?
  end

  # ----------- Booking ---------------------------
  # TODO : Bug Fix in Merchant
  def booking_holders
    if transaction_details.present?
      end_user_used_deals.where("booking_code_id is not null").transaction_refund
    else
      end_user_used_deals.where("booking_code_id is not null")
    end
  end

  def is_last_coupons_available_for_booking?(booking_details = {})
    return true unless is_last_minute_deal? 
    t_start = Time.zone.parse(booking_details[:time_slot_start_time].to_s)
    t_end = Time.zone.parse(booking_details[:time_slot_end_time].to_s)

    t_start.present? && t_end.present? && (Time.zone.now < t_end) && (total_left > 0)
  end

  def remaining_last_coupons
    _total = last_coupons.to_i - booking_holders.count
    _total > 0 ? _total : 0
  end

  # booking_details : time_slot_start_time, time_slot_end_time, phone_number, 
  #                   number_of_guests
  def create_booking_code(outlet_id, end_user, transaction_detail = {}, booking_details = {})
    booking_details = {} if booking_details.blank?
    if is_last_coupons_available_for_booking?(booking_details)
      Deal.transaction do
        enduser_used_deal = if is_paid_deal? || is_last_minute_deal?
          if (td = transaction_details.find_by_id(transaction_detail[:id])).present?
            td.update_attributes(payment_status: TransactionDetail::PaymentStatus[:success], payu_id: transaction_detail[:payu_id])
            td.end_user_used_deal
          end   
        else
          end_user_used_deals.create({ end_user_id: end_user.id })
        end
      
        if (merchantable = outlet_id.present? ? outlets.find(outlet_id) : store).present?  &&
            enduser_used_deal.present?
          merchant_user = merchantable.merchant_users.try(:first) || MerchantUser.new(merchantable: merchantable) 
          if (booking_code = merchant_user.get_booking_code(end_user)).present?
            enduser_used_deal.update_attributes({ booking_code_id: booking_code.id }.merge(booking_details))
            store.end_user_follow_stores.where(end_user: end_user).first_or_create
            # Notify by Mail
            EndUserMailer.send_booking_code(end_user, self, booking_code.coupon_code, merchantable).deliver_later

            # Notify by Push notification
            _text = "#{end_user.profile_name} has booked your deal \"#{main_line}\""
            PushNotification::ToMerchantUser::DealBookingJob.perform_later(self, "all", _text)

            booking_code
          end
        end
      end
    end      
  end

  def exceeded_booking_limit?(end_user)
    max_bookings.present? && 
        (end_user_used_deals.where(end_user: end_user).where.not(booking_code_id: nil).count >= max_bookings)
  end
  # ----------- Booking ---------------------------

  # ----------- Transaction ---------------------------
  # NOTE : sha512(key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||SALT)
  # payu_hash_key = Digest::SHA2.new(512).hexdigest("YTOgGl|#{transaction_record.id}|#{deal.discounted_price}|#{transaction_record.product_info}|#{current_user.name}|#{current_user.email}|||||||||||aboE4mJm")
  def create_transaction_detail(end_user, pt = {})
    params_transaction = { cashback_id: pt[:cashback_id], points: pt[:points].present?  ? pt[:points].to_f  : nil , quantity: pt[:quantity], total_amount: pt[:total_amount], product_info: {deal_id: id, outlet_id: pt[:outlet_id]}}
    if is_buyable?
      Deal.transaction do
        td = TransactionDetail.create(params_transaction)
        end_user_used_deals.create({ end_user_id: end_user.id, transaction_detail_id: td.id })
        td
      end
    end  
  end

  def total_bought
    if is_paid_deal?
      transaction_details.where(payment_status: TransactionDetail::PaymentStatus[:success]).map(&:quantity).compact.sum
    else
      end_user_used_deals.where('booking_code_id is not null').count
    end
  end

  def total_left
    self.max_quantity.to_i - self.total_bought
  end

  def is_buyable?
    max_quantity.blank? || total_left > 0
  end

  def settlement_amount(deal_quantity)
    (discounted_price - ((discounted_price * commission_percent.to_f)/100)) * deal_quantity rescue 0
  end

  def commission_amount(deal_quantity)
    ((discounted_price * commission_percent.to_f)/100) * deal_quantity rescue 0
  end

  def internet_handling(deal_quantity)
    ((discounted_price * internet_handling_charges.to_f)/100) * deal_quantity rescue 0
  end
  # ----------- Transaction ---------------------------

  private
  def set_publish_date
    unless @skip_before_save.present?
      self.publish_date = Time.zone.now if publish.present?
    end
  end

  # def set_expiry_date
  #   unless @skip_before_save.present?
  #     self.publish_date = publish_date || Time.zone.now
  #     self.expiry_date = if self.is_last_minute_deal? && duration.blank?
  #       publish_date.end_of_day
  #     else
  #       if (duration.present? and duration != 0)
  #         (publish_date.beginning_of_day + duration.try(:day)).end_of_day
  #       end  
  #     end
  #   end
  # end

  def date_validation
    if notification_time_from.present? &&  
        notification_time_to.present? && 
        notification_time_from > notification_time_to
      errors.add(:notification_time_to, "must be less then notification time from.")
    end
  end

  def main_image_dimensions_validation
    if main_image.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(main_image.queued_for_write[:original].path) 
      if dimensions.width > 500 && dimensions.height > 500
        errors.add(:main_image, 'width and height must be in 500x500')
      end
    end
  end    

  def featured_image_dimensions_validation
    if featured_image.queued_for_write[:original]
      dimensions = Paperclip::Geometry.from_file(featured_image.queued_for_write[:original].path) 
      if dimensions.width > 1024 && dimensions.height > 500
        errors.add(:featured_image,'width and height must be in 1024x500')
      end
    end
  end
end
