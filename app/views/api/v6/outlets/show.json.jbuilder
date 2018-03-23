lat = params[:latitude].to_f
lng = params[:longitude].to_f
store = @outlet.store

json.store_name store.name
json.store_id store.id
json.outlet_locality @outlet.locality
json.outlet_phone @outlet.phone_number
json.is_following_store current_user.follow_store?(store) rescue false
json.steps @outlet.steps(lat, lng)
json.is_club_member current_user.is_club_member?  rescue false
json.store_photo store.store_photo
json.latitude @outlet.latitude
json.longitude @outlet.longitude
json.outlet_share_text @outlet.share_text_url
json.outlet_status @outlet.status

json.deals @deals do |deal|
  total_left = (deal.total_left < 0 || deal.total_bought == 0 && deal.total_left == 0) ? -1 : deal.total_left

  json.id deal.id
	json.title deal.title
	json.deal_photo deal.deal_photo
	json.liked_by_user current_user.favourite_deal?(deal) rescue false
  json.price_flag deal.has_price?
  json.actual_price deal.price.to_i
  json.discounted_price deal.discounted_price.to_i
  json.deal_type deal.deal_type # NOTE : Changed deal_type_to_s to deal_type
  json.total_bought deal.total_bought
  json.total_left total_left
  if deal.deal_type.eql?(Deal::DealType[:lmd])
    # json.daily_quantity_quota deal.daily_quantity_quota
    json.is_expired deal.expired?
    if deal.expired?
      json.minutes deal.live_time_difference
    else
      json.minutes deal.lmd_time_difference.hour*60 + deal.lmd_time_difference.strftime("%M").to_i
    end
    json.time_difference deal.lmd_time_difference.strftime("%H:%M")
  end
  json.cashback_flag deal.cashback_discount.present?
  json.cashback_discount deal.cashback_discount.to_i.to_s + "% cashback" if deal.cashback_discount.present?
end

json.feeds @feeds do |feed|
  reminder = current_user.feed_reminder(feed)
  json.id feed.id
  json.title feed.title
  json.feed_type  feed.feed_type
  json.date feed.publish_date.strftime("#{feed.publish_date.day.ordinalize} %b %Y")
  json.expiry_date feed.expiry_date.strftime("%d-%m-%Y") if feed.expiry_date.present?
  json.description feed.description
  json.photo feed.feed_photo
  json.liked_by_user current_user.favourite_feed?(feed)
  json.is_reminder_set reminder.present?
  json.reminder_id reminder.id if reminder.present?
  json.likes feed.end_user_feed_favourites.count
  json.feed_share_text feed.share_text_url
  json.comments 4
  json.attachments 0
end

json.status status
