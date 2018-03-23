class Api::V1::RegistrationsController < Api::V1::BaseController
  before_filter :end_user_authorize!, except: [:create]
  before_filter :client_api_authorize!, only: [:create]

  def create
    login_type = 0 # Email login
    user = EndUser.create_with_login_type(login_type, params[:email], params[:password])
    if user.errors.present?
      render_error(422, user.errors.full_messages.to_sentence)
    else
      device_type = params[:device_type].to_i
      pn_id = params[:pn_id]
      user.update_attributes(name: params[:name])
      EndUserMailer.welcome_email(user).deliver_later
      access_token = Doorkeeper::AccessToken.create!(application_id: current_client_api.id, 
        resource_owner: user,
        device_type: device_type, pn_id: pn_id,
        login_type: login_type)
      
      render_success(access_token: access_token.token)
    end
  end

  def update
    photo = if params[:photo].present?
      params[:photo]=='0' ? nil : params[:photo]
    else
      current_user.photo
    end

    current_user.update_attributes( gender: params[:gender], age: params[:age], 
      is_profile_update: true, photo: photo, name: params[:name])   
    if current_user.errors.present?
      render_error(400, current_user.errors.full_messages.to_sentence)
    else
      render_success(isCategoriesSet: current_user.is_categories_set,
        profile_photo: current_user.profile_photo)  
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
