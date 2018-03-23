# To create Doorkeeper default app
puts "========> Creating API Application : start" 
xapp = Doorkeeper::Application.first
app = xapp.present? ? xapp : Doorkeeper::Application.new
app.name = Settings.doorkeeper_api.name, 
app.redirect_uri = Settings.doorkeeper_api.redirect_uri,
app.uid = Settings.doorkeeper_api.client_id,
app.secret = Settings.doorkeeper_api.client_secret
app.save!
puts "=> Name : #{app.name}"
puts "=> UID : #{app.uid}"
puts "=> Secret : #{app.secret}"
puts "========> Creating API Application : end"

# Google
# -------------------------------------------
puts  "========> Google app for end user: start"
xgcm_app = RailsPushNotifications::Notification.find_gcm_app
gcm_app = xgcm_app.present? ? xgcm_app :  RailsPushNotifications::GCMApp.new
gcm_app.gcm_key = Settings.push_notification.google.end_user_app.gcm_key
gcm_app.save!
puts  "========> Google app for end user: end"

puts  "========> Google app for merchant: start"
xgcm_app = RailsPushNotifications::Notification.find_gcm_app(:merchant)
gcm_app = xgcm_app.present? ? xgcm_app :  RailsPushNotifications::GCMApp.new(app_type: 'merchant')
gcm_app.gcm_key = Settings.push_notification.google.merchant_app.gcm_key
gcm_app.save!
puts  "========> Google app for merchant: end"
# -------------------------------------------

# Apple
# use rake db:seed RAILS_ENV=production for sandbox mode in production
# -------------------------------------------
puts  "========> Apple app for end user : start"
xapns_app = RailsPushNotifications::Notification.find_apns_app
apns_app = xapns_app.present? ? xapns_app :  RailsPushNotifications::APNSApp.new
apns_app.apns_dev_cert = File.read(Settings.push_notification.apple.end_user_app.apns_dev_cert)
apns_app.apns_prod_cert = File.read(Settings.push_notification.apple.end_user_app.apns_prod_cert)
apns_app.sandbox_mode = Rails.env == 'development'
apns_app.save!
puts  "=> Apple app as sandbox - #{apns_app.sandbox_mode}"
puts  "========> Apple app for end user : end"

puts  "========> Apple app for merchant : start"
xapns_app = RailsPushNotifications::Notification.find_apns_app(:merchant)
apns_app = xapns_app.present? ? xapns_app :  RailsPushNotifications::APNSApp.new(app_type: 'merchant')
apns_app.apns_dev_cert = File.read(Settings.push_notification.apple.merchant_app.apns_dev_cert)
apns_app.apns_prod_cert = File.read(Settings.push_notification.apple.merchant_app.apns_prod_cert)
apns_app.sandbox_mode = Rails.env == 'development'
apns_app.save!
puts  "=> Apple app as sandbox - #{apns_app.sandbox_mode}"
puts  "========> Apple app for merchant : end"
# -------------------------------------------


puts  "========> Api Detail : start"
ApiDetail.find_or_create_by(api_version: 'v1', device_type: 0) ## For Android
ApiDetail.find_or_create_by(api_version: 'v1', device_type: 1) ## For Apple
ApiDetail.find_or_create_by(api_version: 'v1-merchant', device_type: 0) ## For Android
ApiDetail.find_or_create_by(api_version: 'v1-merchant', device_type: 1) ## For Apple
puts  "========> Api Detail : end"

puts  "========> Populate Country : start"
Country.find_or_create_by(name: "India", server_url: "http://alldealzz-live.herokuapp.com", logo_url: nil, isd_code: "+91", has_exclusive_club: true, has_brands: true)
Country.find_or_create_by(name: "United Kingdom", server_url: "http://alldealzz-uk.herokuapp.com", logo_url: nil, isd_code: "+44", has_exclusive_club: false, has_brands: false)
puts  "========> Country : end"