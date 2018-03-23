class Api::Doorkeeper::SalesUserTokensController < Api::Doorkeeper::TokensController
  def create
    create_token_response do |response, response_body|
      if response.present? && (response.is_a? Doorkeeper::OAuth::TokenResponse) && (user = api_user(response.token))
        login_type = 3
        device_type = params[:device_type].to_i
        pn_id = params[:pn_id]
        
        response.token.update_attributes(device_type: device_type, pn_id: pn_id,
          login_type: login_type, resource_owner_type: user.class)

        self.response_body = response_body.merge({}).to_json
      end
    end
  rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end
  
  private

  def api_user(access_token)
    SalesUser.find(access_token.resource_owner_id) if access_token
  end
end
