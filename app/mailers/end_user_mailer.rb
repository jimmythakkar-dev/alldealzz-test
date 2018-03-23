class EndUserMailer < ApplicationMailer
  layout false

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.end_user_mailer.reset_password.subject
  #
  def reset_password(user)
    @user = user
    if @user.email.present?
  	  mail(to: @user.email, subject: "Reset your password - #{Settings.app_name}")
    end  
  end

  def welcome_email(user)
    @user = user
    if @user.present? && @user.email.present?
      mail(to: @user.email, 
        subject: "Welcome to #{Settings.app_name}")
    end
  end

  def send_booking_code(user, deal, coupon_code, merchantable)
    @user = user
    @mainline = deal.main_line
    @merchantable = merchantable
    @store_name = merchantable.try(:name) || merchantable.try(:store).try(:name)
    @coupon_code = coupon_code
    @expiry_date = deal.expiry_date.strftime("%B %d, %Y") rescue nil
    @encrypt = deal.id + 1000
    if @user.present? && @user.email.present?
      mail(to: @user.email, bcc: Settings.mail.bookings, subject: "All Dealzz | Your #{@store_name} deal has been booked") do |format|
        if deal.is_last_minute_deal? || deal.is_paid_deal?
          @transaction_details = BookingCode.where(coupon_code: coupon_code).last.end_user_used_deal.transaction_detail
          format.html { render 'paid_deal' }
        else
          format.html { render 'booked_deal' }
        end
      end
    end
  end

  def send_otp_code(user, otp_code)
    @otp_code = otp_code
    if user.present? && user.email.present?
      mail(from: Settings.otp_email.username, to: user.email,
           subject: "All Dealzz | Your One Time Password")
    end
  end
end
