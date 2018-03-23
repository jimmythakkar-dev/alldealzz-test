class Api::V2::Local::BaseController < Api::V2::BaseController
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
    store_ids = params[:store_ids].present? ? params[:store_ids].split(',').map(&:strip) : []
    outlet_ids = params[:outlet_ids].present? ? params[:outlet_ids].split(',').map(&:strip) : []
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
	  PushNotification::ToEndUser::LocationBasedJob.perform_later(doorkeeper_token, lat, lng, store_ids, outlet_ids)
    render_success
  end

  def is_city_valid
    city = params[:city].titleize
    city_valid = Store::Cities.include?(city)
    if city_valid
      render_success(isCityValid: true)
    else
      render_success(isCityValid: false,message: "We are not operational in this city, Yet!")
    end
  end

  def request_otp
    otp_code = SecureRandom.hex(2).upcase
    update_flag = current_user.update_attributes(otp_requested: true, otp_code: otp_code)
    if update_flag
      EndUserMailer.send_otp_code(current_user, otp_code).deliver_now
      render_success(message: "OTP sent to your email address")
    else
      render_error(422, "Sorry, OTP Code not sent")
    end
  end

  def verify_otp
    otp_code = params[:otp_code]
    otp_valid = otp_code.present? && current_user.otp_code.present? && otp_code.upcase == current_user.otp_code
    if otp_valid
      current_user.update_attributes(otp_verified: true)
      render_success(message: "OTP verified successfully, you may proceed to book the deal")
    else
      render_error(422, "Please enter valid OTP code")
    end
  end

  def update_email
    current_user.update_attributes(email: params[:email], otp_verified: false, otp_requested: false) if params[:email].present?
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    else
      render_success(message: "Email Address updated successfully")
    end
  end

  def verify_phone_otp
    current_user.update_attributes(phone_verified: true, phone_number: params[:phone_number])
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    else
      render_success(message: "Your mobile number has been verified sucessfully!!")
    end
  end

  ## Payment status 0: pending, 1: successful, 2: failed
  def update_payment_status
    TransactionDetail.find_by_id(params[:transaction_id]).update_attributes(payment_status: params[:payment_status].to_i, payu_id: params[:payu_id])
    render_success(message: "Updated Status successfully")
  end

  private

  def unreviewed_deals
    redeemed_deals = current_user.used_deals.redeemed_deals
    unrated_deals = []
    if redeemed_deals.present?
      redeemed_deals.each do |deal|
        unrated_deals << deal unless deal.end_user_deal_reviews.where(end_user_id: current_user.id).present?
      end
    end
    # Below code is asking for review everytime for the same deals hence reverting
    # unrated_deals = redeemed_deals.select {|deal| deal.end_user_deal_reviews.present? }
    unrated_deals.map do |deal|
      {
          id: deal.id,
          main_line: deal.main_line,
          store_name: deal.store.name
      }
    end
  end

  def api_detail_result(api_detail, option = {})
    { version: api_detail.app_version, 
      device_type: api_detail.device_type? ? "Apple" : "Android", 
      type: api_detail.app_type, 
      message: api_detail.message,
      unreviewed_deals: unreviewed_deals, 
      has_lmd_deals: true, has_ex_deals: true
    }.merge(option)
  end
end  