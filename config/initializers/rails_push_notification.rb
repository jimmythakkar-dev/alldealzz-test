RubyPushNotifications::APNS::APNSConnection.instance_eval do
  def open(cert, sandbox)
  ctx = OpenSSL::SSL::SSLContext.new
  ctx.key = OpenSSL::PKey::RSA.new cert, Settings.push_notification.apple.passphrase
  ctx.cert = OpenSSL::X509::Certificate.new cert

  h = host sandbox
  socket = TCPSocket.new h, RubyPushNotifications::APNS::APNSConnection::APNS_PORT
  ssl = OpenSSL::SSL::SSLSocket.new socket, ctx
  ssl.connect

  new socket, ssl
  end
end

RailsPushNotifications::Notification.instance_eval do
  belongs_to :end_user
  belongs_to :sendible, polymorphic: true
  # before_save :increase_quota
    
  # private
  # class_eval do
  #   def increase_quota
  #     self.class.transaction do
  #       if [sendible, end_user, sent, success].all?
  #         sendible.create_notification_analytics(end_user)
  #       end
  #     end    
  #   end
  # end

  after_save :create_notification_analytics
  after_create :increase_quota_for_premium_notification

  validate :store_should_have_quota_for_premium_notification
  
  class_eval do
    def store_should_have_quota_for_premium_notification
      if sendible.present? && sendible.is_a?(PremiumNotification) &&
        sendible.quotum.present? && 
        sendible.quotum.premium_notification_used >= sendible.quotum.premium_notification_total
        errors.add(:sendible_id, "store should have quota for premium notification")
      end
    end

    def resource_owners
      return [end_user] if end_user.present?
      app_type = app.app_type rescue ''
      of_users_by_app_type = case app_type
      when 'merchant'
        :of_merchant_users
      when 'sales_user'
        :of_sales_users
      else
        :of_end_users
      end
      
      Doorkeeper::AccessToken.try(of_users_by_app_type).where(pn_id: destinations).map { |e| e.resource_owner }.uniq
    end

      
    private
    def create_notification_analytics
      if sendible.present? && end_user.present? && 
        (success_was != 1) && (success == 1) && (failed == 0)
        sendible.create_notification_analytics(end_user)
      end   
    end

    def increase_quota_for_premium_notification
      if sendible.present? && end_user.present? && 
        sendible.is_a?(PremiumNotification)
        sendible.increse_quota
      end
    end 
  end

  def self.sent_true!
    where(sent: false).update_all(sent: true)
  end
  
  # type : :end_user, :merchant
  def self.find_gcm_app(type = :end_user)
    RailsPushNotifications::GCMApp.find_by_app_type(type)
  end
  
  # type : :end_user, :merchant
  def self.find_apns_app(type = :end_user)
    RailsPushNotifications::APNSApp.find_by_app_type(type)
  end
end