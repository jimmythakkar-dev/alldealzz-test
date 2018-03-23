class Api::V6::PasswordResetsController < Api::V6::BaseController
  before_filter :client_api_authorize!

  def create
    if params[:email].present? && (user = EndUser.find_by_email(params[:email]))
    	user.send_reset_password
      render_success(message: "Password has been mailed to your registered email.")
    else
      render_error(404, "Email is not registered.")
    end	
  end
end