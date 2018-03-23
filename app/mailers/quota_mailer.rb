class QuotaMailer < ApplicationMailer
  layout 'mailer/sales1'

	def finished_quota_email(quota, persent)
    @user = user
    @url  = Settings.main_uri
    @store = @user.store
    @quota = @user.store.quotum
    if @store.present? && @quota.present? && @user.email.present?
	    mail(to: @user.email, 
	    	subject: "Welcome #{@store.name.capitalize} - #{Settings.app_name}")
    end
  end
end
