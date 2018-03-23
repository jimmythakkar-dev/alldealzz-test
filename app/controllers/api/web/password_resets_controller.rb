class Api::Web::PasswordResetsController < Api::Web::ApplicationController 
  def edit
	  @user = EndUser.find_by_reset_password_token(params[:id])
	end

	def update
    @updated = false
	  @user = EndUser.find_by_reset_password_token!(params[:id])
	  if @user.reset_password_is_expired?
      flash[:alert] = 'Password reset has expired.'
	  elsif @user.reset_password(params[:end_user][:password], params[:end_user][:password_confirmation])
      @updated = true
	  end
	end
end