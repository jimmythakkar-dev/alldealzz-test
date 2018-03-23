class MerchantMailer < ApplicationMailer
layout false
	def send_payment_merchant(user)
		@user = user
		if @user.present? 
			mail(to: @user.email, bcc: Settings.mail.bookings, subject: "All Dealzz |  #{@user.username} payment success") do |format|
				format.html { render 'send_payment_merchant' }
			end
		end
	end
end