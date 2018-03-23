class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  check_authorization :unless => :exempt_controller?
    rescue_from CanCan::AccessDenied, :with => :access_denied

  before_action :configure_permitted_parameters, if: :devise_controller? 
  before_action :find_managable, if: :current_user  

  private
  
  def exempt_controller?
    devise_controller? || payu_controller? || other_controller? || paytm_controller? || stripe_controller?
  end

  def devise_controller?
    %(sessions passwords registrations).include? controller_name
  end

  def payu_controller?
    %(payu/callbacks).include? controller_path
  end

  def paytm_controller?
    %(paytm/callbacks).include? controller_path
  end

  def stripe_controller?
    %(paytm/callbacks).include? controller_path
  end

  def other_controller?
    false
  end  

  def access_denied
    deny_access("You are not authorized to access that page.")
  end

  def deny_access(flash_message = nil)
    if request.xhr?
      head 401
    else
      flash[:alert] = flash_message if flash_message
      redirect_to(root_path)
    end
  end

  def find_managable
    if current_user.store_admin?
      @store = current_user.store 
    elsif current_user.mall_admin?
      @mall = current_user.mall
    end  
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:username, :email, :password, :password_confirmation, :remember_me) }
    devise_parameter_sanitizer.for(:sign_in) { |u| u.permit(:login, :username, :email, :password, :remember_me) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:username, :email, :password, :password_confirmation, :current_password) }
  end
end
