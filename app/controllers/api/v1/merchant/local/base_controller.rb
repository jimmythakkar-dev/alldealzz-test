class Api::V1::Merchant::Local::BaseController < Api::V1::Merchant::BaseController
  before_action :merchant_user_store_authorize!
  
  # Type : 1-Normal Update
  #        2-Forcefully Update
  def app_update
  	api_detail = ApiDetail.find_by(api_version: 'v1-merchant', device_type: 0)
    render_success(api_detail_result(api_detail)) 
  end

  def ios_update
    api_detail = ApiDetail.find_by(api_version: 'v1-merchant', device_type: 1)
    render_success(api_detail_result(api_detail))  
  end

  def contact_details
    render_success(phone_number: '+44 7484 869774', email: 'support.uk@alldealzz.com')
  end

  private

  def api_detail_result(api_detail, option = {})
    { version: api_detail.app_version, 
      device_type: api_detail.device_type? ? "Apple" : "Android", 
      type: api_detail.app_type, 
      message: api_detail.message,
      total_followers: @store.end_user_follow_stores.count }.merge(option)
  end 
end  