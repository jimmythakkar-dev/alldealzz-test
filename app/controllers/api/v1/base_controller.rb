class Api::V1::BaseController < ActionController::Base
  require 'core_base/object'

  respond_to :json

  def doorkeeper_unauthorized_render_options
    {:json => error_response(401, "Not authorized")}
  end

  rescue_from StandardError, with: :show_errors unless Rails.env == "development"
  
  rescue_from ActiveRecord::RecordNotFound do |e|
    if e.message.include?("IDs")
      klass = /^Couldn't find all (\w+) with (id=([\S]*))?/.match(e.message)[1]
    else
      klass = /^Couldn't find (\w+) with (id=([\S]*))?/.match(e.message)[1]
    end
    render json: error_response(404, "#{klass} Not Found"), status: 404
  end

  rescue_from ActiveRecord::RecordInvalid, with: :show_errors

  def routing_error_api
    raise ActionController::RoutingError.new("No route matches \"/api/#{params[:path]}\"")
  end

  def render_error(status_code, msg)
    render json: error_response(status_code, msg), status: status_code      
  end

  def render_success(options = {})
    template = options.delete(:template)
    if template.present?
      render template, locals: options.merge(status: 200), status: :ok
    else  
      render json: options.merge(status: 200), status: :ok
    end  
  end

  protected

  def error_response(status_code, message)
    { error: {message: message}, status: status_code}
  end

  def show_errors(exception)
    render json: error_response(500, exception.message), status: 500
  end

  def default_v1_api_opts( opts = {})
    opts.merge({v1_api: true})
  end

  # -------------------------------------------------
  def doorkeeper_client_api
    Doorkeeper::Application.find_by_uid_and_secret(params[:client_id], params[:client_secret]) || doorkeeper_token.try(:application)
  end

  def current_client_api
    @current_client_api ||= doorkeeper_client_api
  end

  def client_api_authorize!
    if doorkeeper_client_api.blank?
      render json: {
        error: "invalid_client",
        error_description: "Client authentication failed due to unknown client, no client authentication included, or unsupported authentication method."}, 
        status: 401
    end
  end

  def sales_user_authorize!
    doorkeeper_authorize! and return
    unless current_user.is_a?(SalesUser)
      render_error(401, 'Not a sales user')
    end  
  end

  def merchant_user_authorize!
    if doorkeeper_token.blank?
      authenticate_user! and return
    else
      doorkeeper_authorize! and return
    end  
    unless current_user.is_a?(MerchantUser)
      render_error(401, 'Not a merchant user')
    end  
  end

  def end_user_authorize!
    doorkeeper_authorize! and return
    unless current_user.is_a?(EndUser)
      render_error(401, 'Not a End user')
    end  
  end

  def current_user
    @current_user ||= if doorkeeper_token
      doorkeeper_token.resource_owner
    else
      MerchantUser.find_by_id(params[:merchant_user_id])
    end  
  end
  # -------------------------------------------------
end
