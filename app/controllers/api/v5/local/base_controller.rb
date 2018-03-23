class Api::V5::Local::BaseController < Api::V5::BaseController
  before_action :end_user_authorize!, except: [:app_update, :ios_update]
  
  # Type : 1-Normal Update
  #        2-Forcefully Update
  def app_update
  	api_detail = ApiDetail.where(api_version: 'v1', device_type: 0).last
    render_success(api_detail_result(api_detail)) 
  end

  def ios_update
    api_detail = ApiDetail.where(api_version: 'v1', device_type: 1).last
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
    phone_number = params[:phone_number].first(10)
    current_user.update_attributes(phone_verified: true, phone_number: phone_number)
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    else
      render_success(message: "Your mobile number has been verified sucessfully!!")
    end
  end

  ## Payment status 0: pending, 1: successful, 2: failed
  def update_payment_status
    transaction_detail = TransactionDetail.find_by(id: params[:transaction_id])
    transaction_detail.update_attributes(payment_status: params[:payment_status].to_i, payu_id: params[:payu_id])
    if transaction_detail.payment_status.eql?(2).present?
      transaction_detail.cashback_refund_pending_settlement(current_user.id)
    end
    render_success(message: "Updated Status successfully")
  end

  def update_pn_id
    token = Doorkeeper::AccessToken.find_by(token: params[:token])
    if token.present?
      token.update_attributes(pn_id: params[:pn_id])
      if token.errors.present?
        render_error(422, token.errors.full_messages.to_sentence)
      else
        render_success(message: "Pn_id updated successfully")
      end
    else
      render_error(422, "Token Doesn't exists")
    end
  end

  def unreviewed_deals_listing
    render_success(unreviewed_deals: unreviewed_deals)
  end

  def configuration
    render_success(unreviewed_deals: unreviewed_deals, email: current_user.email, name: current_user.name,
                   phone_number: current_user.phone_number, profile_photo: current_user.profile_photo,
                   age: current_user.age, gender: current_user.gender, is_club_member: current_user.is_club_member?,
                   is_email_verified: current_user.otp_verified?,
                   club_expiry_date: current_user.try(:membership_expiry_date).try(:strftime, '%a, %d %b %Y'),
                   city_id: current_user.city_id, city_name: current_user.city.try(:name), cat_version: CategoryVersion.first.version)
  end

  def payment_options
    payment_options = PaymentOption.where(status: true).map do |pay_option|
      {
          id: pay_option.id,
          name: pay_option.name
      }
    end
    render_success(payment_options: payment_options)
  end

  private

  def unreviewed_deals
    redeemed_deals = current_user.used_deals.redeemed_deals rescue nil
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

  def check_update(api_detail)
    current_detail = ApiDetail.find_by(app_version: params[:current_version], device_type: api_detail.device_type)
    details = nil
    if current_detail.present?
      current_type = current_detail.device_type
      current_id = current_detail.id
      api_detail_id = api_detail.id
      details = ApiDetail.where(device_type: current_type, api_version: current_detail.api_version).where("api_details.id > ? AND api_details.id <= ?", current_id, api_detail_id).map(&:app_type)
    else
      details = ApiDetail.where(device_type: api_detail.device_type, api_version: api_detail.api_version).map(&:app_type)
    end
    if details.include?("2")
      "2"
    else
      "1"
    end
  end

  def api_detail_result(api_detail, option = {})
      current_version = params[:current_version].present? ? params[:current_version] : "1"
      has_brands = params[:country_id].present? ? Country.find_by(id: params[:country_id]).try(:has_brands) : true
      has_cashback = false
      if api_detail.device_type?
        has_cashback = current_version != "3.4.6" && current_version >= api_detail.app_version ? true : false
      else
        has_cashback = current_version != "48" && current_version >= api_detail.app_version ? true : false
      end
      has_exclusive = params[:country_id].present? ? Country.find_by(id: params[:country_id]).try(:has_exclusive_club) : true
    { version: api_detail.app_version,
      device_type: api_detail.device_type? ? "Apple" : "Android",
      type: check_update(api_detail),
      message: api_detail.message,
      has_brands: false, has_exclusive: false, has_cashback: has_cashback
    }.merge(option)
  end
end