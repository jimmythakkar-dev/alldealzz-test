json.data @deal_reviews do |review|
  user = review.end_user
  json.user_name user.name || user.email
  json.review_text review.message
  json.rating review.rating.to_i
  json.profile_photo user.profile_photo
end