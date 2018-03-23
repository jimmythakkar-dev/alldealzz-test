namespace :scheduler do
  namespace :notification do
    desc "Rate store once the deal is redeemed by the merchant"
    Time.zone = Settings.app_timezone
    task rate_store: :environment do
      p "==Current Time by zone===#{Time.zone.now}"
      booking_codes = BookingCode.where('redeemed_at BETWEEN ? AND ?', (Time.zone.now - 2.hour),  (Time.zone.now - 0.hour))
      booking_codes.each do |bc|
        if bc.end_user && bc.merchant_user
          filted_options = {
            target_to: 'all',
            target_end_user_id: bc.end_user.id
          }
          options = {}
          message = "Please rate your experience @ #{bc.merchant_user.store.try(:name)}" 
          PushNotification::ToEndUser::SenderRequestedJob
            .perform_now(bc.merchant_user, message, filted_options, options)
        end 
      end  
    end
  end
end
