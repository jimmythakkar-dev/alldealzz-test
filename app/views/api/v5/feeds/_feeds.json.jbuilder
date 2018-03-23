json.feeds feeds do |feed|
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
  json.comments 4
  json.attachments 0
  # json.price_flag feed.has_price?
  # json.actual_price feed.price
  # json.discounted_price feed.discounted_price
end
