class Api::V5::RegistrationsController < Api::V5::BaseController
  before_filter :end_user_authorize!, except: [:create, :check_social_phone_number]
  before_filter :client_api_authorize!, only: [:create]

  # def create
  #   login_type = 0 # Email login
  #   user = EndUser.create_with_login_type(login_type, params[:email], params[:password])
  #   if user.errors.present?
  #     render_error(422, user.errors.full_messages.to_sentence)
  #   else
  #     device_type = params[:device_type].to_i
  #     pn_id = params[:pn_id]
  #     user.update_attributes(name: params[:name])
  #     # EndUserMailer.welcome_email(user).deliver_later
  #     access_token = Doorkeeper::AccessToken.create!(application_id: current_client_api.id,
  #       resource_owner: user,
  #       device_type: device_type, pn_id: pn_id,
  #       login_type: login_type)
  #
  #     render_success(access_token: access_token.token, email: user.email)
  #   end
  # end

  def create
    login_type = params[:login_type].to_i
    ## TODO sid, photo, name update
    phone_number = params[:phone_number].first(10)
    user = EndUser.create_with_phone_number(phone_number)
    if user.errors.present?
      render_error(422, user.errors.full_messages.to_sentence)
    else
      device_type = params[:device_type].to_i
      pn_id = params[:pn_id]
      user.update_attributes(name: params[:name])
      user.update_attributes(email: params[:email]) if params[:email].present?
      user.update_attributes(photo_url: params[:photo_url]) if params[:photo_url].present?
      user.update_attributes(EndUser::LOGIN_TYPE[login_type] => params[:sid]) if params[:sid].present?
      user.deal_categories = DealCategory.all
      user.is_categories_set = true
      user.save
      access_token = Doorkeeper::AccessToken.create!(application_id: current_client_api.id,
                                                     resource_owner: user,
                                                     device_type: device_type, pn_id: pn_id,
                                                     login_type: login_type)

      render_success(access_token: access_token.token, email: user.email, name: user.name, phone_number: user.phone_number)
    end
  end

  def check_social_phone_number
    login_type = params[:login_type].to_i
    existing_phone_user = EndUser.find_with_phone_number(3, params[:phone_number])
    existing_social_user = case login_type
      when 1, 2
        EndUser.find_with_login_type(login_type, params[:sid])
      when 0
        EndUser.authenticate(params[:email], params[:password])
     end

    allow_update = if existing_social_user.present? && existing_social_user.phone_number == params[:phone_number]
                    true
                  elsif existing_social_user.present? && existing_phone_user.blank?
                    true
                  elsif existing_social_user.blank? && existing_phone_user.blank?
                    true
                  elsif existing_social_user.present? && existing_social_user.phone_number != params[:phone_number]
                     false
                  elsif existing_social_user.blank? && existing_phone_user.present?
                    false
                  end
    if allow_update
      message = "success"
    else
      message = "This phone number is already linked with an existing account, please enter a different number"
    end

    render_success(allow_update: allow_update, message: message)
  end

  def update
    photo = if params[:photo].present?
      params[:photo]=='0' ? nil : params[:photo]
    else
      current_user.photo
    end
    
    current_user.email = params[:email] || current_user.email if params[:email].present?
    if current_user.email_changed?
      current_user.update(email: current_user.email, otp_verified: false, otp_requested: false)
    end
    current_user.update_attributes( gender: params[:gender], age: params[:age],
    is_profile_update: true, photo: photo, name: params[:name])
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    else
      render_success(isCategoriesSet: current_user.is_categories_set,
        profile_photo: current_user.profile_photo, email: current_user.email)
    end  
  end

  def update_photo
    photo = if params[:photo].present?
              params[:photo]=='0' ? nil : params[:photo]
            else
              current_user.photo
            end

    current_user.update_attributes(photo: photo)
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    else
      render_success(profile_photo: current_user.profile_photo)
    end
  end

  def check_referral_code
    if params[:referral_code].present?
      store = Store.find_by(referral_code: params[:referral_code].upcase)
      if store.present?
        EndUserStoreRefCode.find_or_create_by(end_user_id: current_user.id, store_id: store.id)
        render_success(isRefCodeValid: "true",message: "Referral Code Applied Successfully")
      else
        render_success(isRefCodeValid: "false",message: "Referral Code Invalid!")
      end
    else
      render_success(isRefCodeValid: "false",message: "Please Enter Referral Code")
    end  
  end  
end
