class AppHelpersController < ApplicationController
  authorize_resource class: false
  before_action :authenticate_user!, except: [:api_json_lookup]

  def api_json_lookup
    geocodingAPI = if params[:type] == 'placeid'
      "https://maps.googleapis.com/maps/api/place/details/json?#{URI.encode(params[:type])}=#{URI.encode(params[:value])}&key=#{Settings.google_api_key}"
    else  
      "https://maps.googleapis.com/maps/api/place/autocomplete/json?#{URI.encode(params[:type])}=#{URI.encode(params[:value])}&key=#{Settings.google_api_key}"
    end
    @result = JSON.parse(RestClient.get(geocodingAPI), {:accept => :json})
    respond_to do |format|
      format.json { render json: @result }
      format.js
    end
  end

  def index
  end

  def notify_reset
    OauthAccessTokenDealNotification.delete_all
    # Removed functionality : -----
    EndUserPremiumNotification.delete_all
    EndUserDealNotification.delete_all
    # Removed functionality : -----
    @result = {status: 200}
  end

  def api_details_show
    @api_detail =  if params[:api_detail].present?
      ApiDetail.find_by(params[:api_detail]) || ApiDetail.new
    else
      ApiDetail.new
    end  
    api_details_result(@api_detail)
  end

  def api_details_apple_show
    @api_detail = ApiDetail.find_by(params[])
    api_details_result(@api_detail)
  end

  def api_details_update
    @api_detail = ApiDetail.find_by_id(params[:id])
    if @api_detail.update_attributes(api_detail_params)
      api_details_result(@api_detail)
    end
  end

  def active_google_app
    @result = Doorkeeper::AccessToken.active_google_app.map do |tkn|
      token_result(tkn)  
    end
  end

  def active_apple_app
    @result = Doorkeeper::AccessToken.active_apple_app.map do |tkn|
      token_result(tkn)
    end
  end

  private

  def api_detail_params
    params.require(:api_detail).permit(:app_version, :app_type, :message)
  end

  def api_details_result(api_detail)
    device = api_detail.device_type? ? "Apple" : "Android"
    @result = {api_version: api_detail.api_version, device_type: device, app_version: api_detail.app_version, type: api_detail.app_type, message: api_detail.message}
  end

  def token_result(tkn)
    user = tkn.resource_owner
    result = { user: "#{user.class} : #{user.id}", pn_id: tkn.pn_id, notify_status: tkn.notification_status}
    if user.is_a?(EndUser)
      result.merge({ profile_name: user.profile_name, 
    facebook_uid: user.facebook_uid, google_uid: user.google_uid, age: user.age, gender: user.gender })
    elsif user.is_a?(SalesUser)
      result.merge({user_id: user.identifier, name: user.name, contact_phone: user.contact_phone})
    end
  end
end
