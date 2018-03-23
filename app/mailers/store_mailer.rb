class StoreMailer < ApplicationMailer
  layout 'mailer/sales1'

  def welcome_email(resource, user, password)
    @user = user
    @password = password
    @url  = Settings.main_uri
    @store = resource
    if @store.present? && @user.email.present?
	    mail(to: @user.email, 
	    	subject: "Welcome #{@store.name.capitalize} - #{Settings.app_name}")
    end
  end

  def welcome_email2(resource, user)
    @user = user
    @store = resource
    if @store.present? && @user.email.present?
      mail(to: @user.email, 
        subject: "Welcome #{@store.name.capitalize} - #{Settings.app_name}")
    end
  end
end
