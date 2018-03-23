class Api::Doorkeeper::EndUserTokensController < Api::Doorkeeper::TokensController
  def create
    login_type = params[:login_type].to_i
    if params[:current_version].present?
      end_user = case login_type
      when 1, 2
        EndUser.find_with_login_type(login_type, params[:sid])
        when 0
          EndUser.authenticate(params[:email], params[:password])
        else
          EndUser.find_with_phone_number(login_type, params[:phone_number])
        end
      if end_user && end_user.black_listed == true
          render json: { error: {message: "Your account has been suspended, Please contact All Dealzz at support@alldealzz.com"}, status: 422}, status: 422
      elsif end_user 
        create_token_response do |response, response_body|
          if response.present? && (response.is_a? Doorkeeper::OAuth::TokenResponse) && (user = api_user(response.token))
            device_type = params[:device_type].to_i
            pn_id = params[:pn_id]
            # if login_type == 1 || login_type == 2 ##google or facebook
            #   user.update_attributes(photo_url: params[:photo_url], name: params[:name])
            # end
            response.token.update_attributes(device_type: device_type, pn_id: pn_id,
              login_type: login_type, resource_owner_type: user.class)

            self.response_body = response_body.merge({
                notification_status: response.token.notification_status,
                name: user.name, age: user.age, gender: user.gender,
                city_id: user.city_id, city_name: user.city.try(:name),
                profile_photo: user.profile_photo, email: user.email, phone_number: user.phone_number, user_status: true }).to_json
          end
        end
      else
        render json: { user_status: false}
      end
    else
      create_token_response do |response, response_body|
        if response.present? && (response.is_a? Doorkeeper::OAuth::TokenResponse) && (user = api_user(response.token))
          login_type = params[:login_type].to_i
          device_type = params[:device_type].to_i
          pn_id = params[:pn_id]

          if login_type == 1 || login_type == 2 ##google or facebook
            user.update_attributes(photo_url: params[:photo_url], name: params[:name])
          end
          response.token.update_attributes(device_type: device_type, pn_id: pn_id,
                                           login_type: login_type, resource_owner_type: user.class)

          self.response_body = response_body.merge({ isProfileUpdate: user.is_profile_update,
                                                     isCategoriesSet: user.is_categories_set, isCitySelected: user.city.present?,
                                                     city_id: user.city_id, city_name: user.city.try(:name),
                                                     notification_status: response.token.notification_status,
                                                     name: user.name, age: user.age, gender: user.gender,
                                                     profile_photo: user.profile_photo, email: user.email, phone_number: user.phone_number }).to_json
        end
      end
    end
  rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end

  private

  def api_user(access_token)
    EndUser.find(access_token.resource_owner_id) if access_token
  end
end
 # TOdo: remove in v6 city_id,  city_name, isCitySelected, isProfileUpdate, isCategoriesSet, token_type