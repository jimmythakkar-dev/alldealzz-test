class Api::V1::Local::BaseController < Api::V1::BaseController
  before_action :end_user_authorize!
  
  # Type : 1-Normal Update
  #        2-Forcefully Update
  def app_update
  	api_detail = ApiDetail.find_by(api_version: 'v1', device_type: 0)
    render_success(api_detail_result(api_detail))  
  end

  def ios_update
    api_detail = ApiDetail.find_by(api_version: 'v1', device_type: 1)
    render_success(api_detail_result(api_detail))  
  end


  def notify_store
    store_ids = params[:store_ids].split(',').map(&:strip)
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
	  PushNotification::ToEndUser::LocationBasedJob.perform_later(doorkeeper_token, lat, lng, store_ids)
    render_success
  end

  private

  def api_detail_result(api_detail, option = {})
    { version: api_detail.app_version, 
      device_type: api_detail.device_type? ? "Apple" : "Android", 
      type: api_detail.app_type, 
      message: api_detail.message }.merge(option)
  end 
end  