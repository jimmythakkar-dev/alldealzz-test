Doorkeeper::AccessToken.instance_eval do
  belongs_to :resource_owner, polymorphic: true
  has_many :oauth_access_token_deal_notifications, foreign_key: "oauth_access_token_id"
  has_many :deal_notifications, through: :oauth_access_token_deal_notifications
  
  class_eval do
    include Distanceable

    scope :allow_notify, -> { where(notification_status: true) }
    scope :google_app, -> { where(device_type: true) }
    scope :apple_app, -> { where(device_type: false) }
    
    scope :active_app, -> { where('oauth_access_tokens.revoked_at is null AND oauth_access_tokens.pn_id is not null') }
    scope :active_google_app, -> { active_app.google_app }
    scope :active_apple_app, -> { active_app.apple_app }
    
    scope :active_allow_notify_app, -> { active_app.allow_notify }
    scope :active_allow_notify_google_app, -> { active_google_app.allow_notify }
    scope :active_allow_notify_apple_app, -> { active_apple_app.allow_notify }

    scope :of_end_users, -> { where(resource_owner_type: "EndUser")
        .joins('INNER JOIN end_users ON end_users.id = oauth_access_tokens.resource_owner_id') }
    scope :of_sales_users, -> { where(resource_owner_type: "SalesUser") }
    scope :of_merchant_users, -> { where(resource_owner_type: "MerchantUser") }
    
    scope :end_users_in_age, ->(age_from, age_to) { 
      if [age_from, age_to].all?
        of_end_users.where('end_users.age >= ? and  end_users.age <= ?', age_from, age_to)
      end
     }
    scope :end_users_of_gender, ->(gender = nil) { 
      if gender.present? && gender.in?(['0', '1'])
        genderized = RequestedNotification::GENDER[gender].to_s
        of_end_users.where('end_users.gender = ?', genderized)
      end  
    }

    scope :end_users_of_city, ->(city_id = nil) {
      if city_id.present?
        of_end_users.where('end_users.city_id = ?', city_id)
      end
    }

    scope :end_users_of_root_deal_category, ->(deal_category_id = nil) {
      if deal_category_id.present?
        of_end_users
        .joins('INNER JOIN end_user_categories ON oauth_access_tokens.resource_owner_id = end_user_categories.end_user_id')
        .where('end_user_categories.deal_category_id = ?', deal_category_id)
      end
    }
    
    scope :active_and_notifiable, ->(app_type) {
      case app_type
      when :google
        active_google_app.to_notify_end_users
      when :apple
        active_apple_app.to_notify_end_users
      else
        to_notify_end_users
      end.select('oauth_access_tokens.pn_id').uniq
    }

    scope :store_followers, ->(store) {
      active_allow_notify_app.of_end_users
        .joins('INNER JOIN end_user_follow_stores ON oauth_access_tokens.resource_owner_id = end_user_follow_stores.end_user_id')
        .where('end_user_follow_stores.store_id = ?', store.try(:id))
    }

    scope :of_merchantable, ->(merchantable) {
      active_allow_notify_app.of_merchant_users
        .joins('INNER JOIN merchant_users ON oauth_access_tokens.resource_owner_id = merchant_users.id')
        .where('merchant_users.merchantable_id = ? and merchant_users.merchantable_type = ?', 
          merchantable.try(:id), merchantable.class.name)
    }

    def send_push_notification(notify_params = {})
      text = notify_params.delete(:text)
      sender = notify_params.delete(:sender)
      
      if text.present? && notify_params[:type].present? && notification_status?
        app = get_rails_push_notification_app(resource_owner_type == "MerchantUser" ? :merchant : :end_user)

        if app.present?
          destinations = [pn_id]
          self.class.create_app_notification(app, sender, destinations, resource_owner, text, notify_params)
        end
      end
    end

    def update_location(lat, lng)
      if [lat, lng].all?
        self.geo_coordinate ||= GeoCoordinate.new
        self.geo_coordinate.latitude = lat
        self.geo_coordinate.longitude = lng
        self.geo_coordinate.save
      end
    end
   
    # NOTE : app_type is :gcm, :apns
    def is_device?(app_type)
      (device_type ? :gcm : :apns) == app_type 
    end

    # NOTE : resource_owner_type is :end_user, :merchant
    def get_rails_push_notification_app(resource_owner_type = :end_user)
      if is_device?(:gcm)
        RailsPushNotifications::Notification.find_gcm_app(resource_owner_type)  
      elsif is_device?(:apns)
        RailsPushNotifications::Notification.find_apns_app(resource_owner_type)
      end  
    end  
  end
  
  # app_type = :google, :apple, :all
  # resource_owner_type = 'EndUser', 'MerchantUser', 'SalesUser'
  # notify_params[:type] = -1: global, 0: deal, 1: store, 2: outlet
  def self.send_batche_push_notification(app_type, resource_owner_type = 'EndUser', tmp_notify_params = {})
    notify_params = tmp_notify_params.dup
    text = notify_params.delete(:text)
    sender = notify_params.delete(:sender)

    if text.present? && notify_params[:type].present?
      type = resource_owner_type == "MerchantUser" ? :merchant : :end_user
      apps = []
      apps |= [RailsPushNotifications::Notification.find_gcm_app(type)] if [:google, :all].include?(app_type)
      apps |= [RailsPushNotifications::Notification.find_apns_app(type)] if [:apple, :all].include?(app_type)

      apps.each do |app|
        batches_destinations, in_groups_of_count = if app.is_a?(RailsPushNotifications::GCMApp)
          [ self.active_allow_notify_google_app.select(:pn_id).uniq, 100]
        elsif app.is_a?(RailsPushNotifications::APNSApp)
          [ self.active_allow_notify_apple_app.select(:pn_id).uniq, 25]
        end

        if app.present?
          batches_destinations.in_groups_of(in_groups_of_count, false) do |batches_destination|
            if (destinations = batches_destination.map(&:pn_id)).present?
              create_app_notification(app, sender, destinations, nil, text, notify_params) 
            end  
          end
        end
      end
    end  
  end

  def self.create_app_notification(app, sender, destinations, resource_owner, text, notify_params = {})
    if (n_destinations = destinations.reject(&:blank?)).present?
      data = if app.is_a? RailsPushNotifications::GCMApp
        { 
          message: text
        }.merge(notify_params)
      elsif app.is_a? RailsPushNotifications::APNSApp
        { aps: { 
            alert: text, 
            sound: 'true', badge: 1
          }.merge(notify_params) 
        }
      end

      options = {}
      options[:sendible] = sender
      # end_user_id is not possible because it is in bunch
      options[:end_user_id] = resource_owner if resource_owner.is_a?(EndUser)
      options[:data] = data
      options[:destinations] = n_destinations
      app.notifications.create(options)
      begin
        app.push_notifications
      rescue Exception => e
      ensure
        RailsPushNotifications::Notification.sent_true!
      end
    end  
  end
end
