class UsersController < ApplicationController
  load_and_authorize_resource

  def change_password
    @user ||= current_user
  end

  def update_password
    if @user
      is_credentials_updated = if current_user.super_admin?
        @user.update(update_password_params)
      else
        @user.update_with_password(update_password_params)
      end
      if is_credentials_updated
        sign_in @user, :bypass => true if current_user == @user
        flash.now[:notice] = "Password changed successfully."
      end
    end  
  end
  
  def change_username
    @user ||= current_user
  end

  def update_username
    if @user
      is_credentials_updated = if current_user.super_admin?
        @user.update(update_username_params)
      else
        @user.update_with_password(update_username_params)
      end
      if is_credentials_updated
        sign_in @user, :bypass => true if current_user == @user
        flash.now[:notice] = "Email or User name changed successfully."
      end
    end  
  end
  
  private
    

  def update_password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end

  def update_username_params
    params.require(:user).permit(:current_password, :email, :username)
  end
end
