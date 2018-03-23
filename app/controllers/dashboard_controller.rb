class DashboardController < ApplicationController
  authorize_resource class: false
  before_action :authenticate_user!, only: [:index]

  def index
    if current_user.store_admin?
  	  redirect_to store_dashboard_path(current_user.store)
    elsif current_user.mall_admin?
      redirect_to mall_dashboard_path(current_user.mall)    
    end  
  end

  def stop_pending_delayed_jop
    if params[:type] == 'requested'
      Delayed::Job.where("handler LIKE '%job_class: PushNotification::ToEndUser::SenderRequestedJob%' and last_error is not null").delete_all
    elsif params[:type] == 'all'
      Delayed::Job.where("last_error is not null").delete_all
    end  
  end

  # def notify_all
  #   text = params[:notification_text]
  #   begin
  #     if text.present? && text.length <= 120
  #       @sucess = true
  #       @msg = "Your task is successfully added in queue for \"#{text}\". So please wait, It will take some time to deliver." 
  #     else
  #       @msg = 'Notification text should be present and its character limit is 120.' 
  #     end  
  #   rescue Exception => e
  #     @msg = 'Notification not sent.' 
  #   end
  # end
end
