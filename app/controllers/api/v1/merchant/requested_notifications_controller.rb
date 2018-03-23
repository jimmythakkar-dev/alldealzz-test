class Api::V1::Merchant::RequestedNotificationsController < Api::V1::Merchant::BaseController
  before_action :merchant_user_store_authorize!
  
  def index
    @requested_notifications = current_user.requested_notifications.order('created_at desc').page(params[:page]).per(10)
    render_success(template: :index)
  end

  def create
    @requested_notification = RequestedNotification.create(merchant_user: current_user, 
      message: params[:message], target_to: :followers, target_device: :all)
    if @requested_notification.save
      render_success(message: "Your Notification is under approval, will be send to all the followers once approved.")
    else
      render_error(422, @requested_notification.errors.full_messages.to_sentence)
    end  
  end
end
