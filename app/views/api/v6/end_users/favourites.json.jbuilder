json.is_club_member current_user.is_club_member?
json.deals @deals do |deal|
  store = deal.store
  total_left = (deal.total_left < 0 || deal.total_bought == 0 && deal.total_left == 0) ? -1 : deal.total_left
  json.id deal.id
  json.store_name store.name
  json.title deal.title
  json.deal_photo deal.deal_photo
  json.price_flag deal.has_price?
  json.actual_price deal.price
  json.discounted_price deal.discounted_price
  json.total_bought deal.total_bought
  json.total_left total_left
  json.store_photo deal.store_photo
  json.liked_by_user current_user.favourite_deal?(deal) rescue false
  json.category_id deal.root_deal_category_id
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
  json.deal_type deal.deal_type # NOTE : Changed deal_type_to_s to deal_type
  json.cashback_flag deal.cashback_discount.present?
  json.cashback_discount deal.cashback_discount.to_i.to_s + "% cashback" if deal.cashback_discount.present?
end

json.feeds @feeds do |feed|
  reminder = current_user.feed_reminder(feed)
  json.id feed.id
  json.title feed.title
  json.liked_by_user current_user.favourite_feed?(feed) rescue false
  json.is_expired feed.expired?
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
end

json.status status