class NotificationsController < ApplicationController
  authorize_resource class: false

  def index
  	authorize! :index, :notifications
  	start_date, end_date = (params[:search] || "").split('-')

    @notifications = 
    	RailsPushNotifications::Notification.all
      .where( [start_date, end_date].all? ? ['DATE(updated_at) BETWEEN ? and ?', start_date, end_date] : [] )
      .order(updated_at: :desc).page(params[:page]).per(10)
  end
end
