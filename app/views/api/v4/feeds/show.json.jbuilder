
json.data do
  reminder = current_user.feed_reminder(@feed)
  json.id @feed.id
  json.title @feed.title
  json.feed_type  @feed.feed_type
  json.publish_date @feed.publish_date.strftime("%d-%m-%Y")
  json.expiry_date @feed.expiry_date.strftime("%d-%m-%Y") if @feed.expiry_date.present?
  json.store_logo @store.store_photo
  json.store_id @store.id
  json.description @feed.description
  json.termsandconditions @feed.termsandconditions.present? ? @feed.termsandconditions.split("\r\n") : []
  json.features @feed.termsandconditions.present? ? @feed.termsandconditions.split("\r\n") : []
  json.valid_days @days
  json.photos  @feed.feed_photo.present? ? [@feed.feed_photo] : []
  json.liked_by_user current_user.favourite_feed?(@feed)
  json.is_reminder_set reminder.present?
  json.reminder_id reminder.id if reminder.present?
  json.likes @feed.end_user_feed_favourites.count
  json.feed_share_text @feed.share_text_url
  json.outlets @feed.outlets.pluck(:locality)
  json.comments 4
  json.attachments 0
end
json.status status
