json.data @feed_reviews do |review|
  user = review.end_user
  json.user_name user.name || user.email
  json.comment review.message
  json.profile_photo user.profile_photo
end