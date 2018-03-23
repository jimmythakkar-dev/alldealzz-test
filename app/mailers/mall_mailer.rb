class MallMailer < ApplicationMailer
  layout 'mailer/sales1'

	def welcome_email(resource, user, password)
    @user = user
    @password = password
    @url  = Settings.main_uri
    @mall = resource
    if @mall.present? && @user.email.present?
	    mail(to: @user.email, 
	    	subject: "Welcome #{@mall.name.capitalize} - #{Settings.app_name}")
    end
  end

  def welcome_email2(resource, user)
    @user = user
    @mall = resource
    if @mall.present? && @user.email.present?
      mail(to: @user.email, 
        subject: "Welcome #{@mall.name.capitalize} - #{Settings.app_name}")
    end
  end
end
