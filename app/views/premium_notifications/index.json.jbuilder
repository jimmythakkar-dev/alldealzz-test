json.array!(@premium_notifications) do |premium_notification|
  json.extract! premium_notification, :id, :notification_text, :radius, :latitude, :longitude, :publish, :publish_date, :duration, :notification_time_from, :notification_time_to, :days
  json.url store_premium_notification_url(@store, premium_notification, format: :json)
end
