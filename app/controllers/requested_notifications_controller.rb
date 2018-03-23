class RequestedNotificationsController < ApplicationController
	load_and_authorize_resource
  before_filter :load_merchant_user

  def new
  end

  def index
    @merchant_user_requested_notifications = @requested_notifications
      .order('created_at desc').page(params[:page]).per(10)
  end

  def show
    
  end

  def create
    @requested_notification = RequestedNotification.new(requested_notification_params)
    begin
      if @requested_notification.save
        @sucess = true
        @requested_notification = RequestedNotification.new
        @msg = "Your task is successfully added in queue. So please approve it and hit deliver. <a href='/requested_notifications'>click here</a>".html_safe 
      else
        @merchantable = @requested_notification.merchantable
        @deals = merchantable_enabled_deals(@merchantable)
      end  
    rescue Exception => e
      @msg = 'Notification not sent.' 
    end
    render :form
  end

  def merchantable_form
    @merchantable = GlobalID::Locator.locate(params[:global_merchantable])
    @deals = merchantable_enabled_deals(@merchantable)
  end

  def dealable_form
    @deal = Deal.find_by_id(params[:deal_id])
  end

  def approve
    @requested_notification.approve!(current_user)
    render :show
  end

  def reject
    @requested_notification.reject!(current_user)
    render :show
  end

  def deliver
    @requested_notification.deliver!(current_user)
    render :show
  end

  private

  def load_merchant_user
    if params[:merchant_id].present?
      @merchant_user = MerchantUser.find(params[:merchant_user])
      @requested_notifications = @merchant_user.requested_notifications
    else
      @requested_notifications = RequestedNotification.all#where(merchant_user_id: nil)
    end
  end

  def requested_notification_params
    params[:requested_notification][:target_to] ||= 'all' 
    params.require(:requested_notification).permit(:target_device, :notification_type,
      :global_merchantable, :target_to, :message, :deal_id, 
      :target_age_from, :target_age_to, :target_gender, :target_is_age_limit, 
      :city_id, :target_deal_category_id)
  end

  def merchantable_enabled_deals(merchantable)
    merchantable.try(:deals).try(:enabled_deals)
  end
end
