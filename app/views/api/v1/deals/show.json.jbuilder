deal = @deal
store = deal.store

json.data do
  json.id deal.id
  json.store_logo deal.store_photo
  json.store_id deal.store.id
  json.feature_image deal.featured_photo
  json.store_name deal.store.name
  json.is_following_store current_user.follow_store?(deal.store)
  json.is_deal_used current_user.deal_used?(deal)
  json.expiry_date deal.package_days
  json.is_user_like current_user.favourite_deal?(deal)
  json.have_coupon deal.is_coupon
  json.coupon_text deal.coupon_text.present? ? deal.coupon_text : nil
  json.coupon_image deal.coupon_photo
  json.is_expired deal.expired?
  json.share_text deal.share_text_url
  json.details do
    json.main_line deal.title
    json.description deal.description
  end
  json.contact do
    json.store_phone store.contact_phone
    json.store_address store.address
    json.latitude store.latitude
    json.longitude store.longitude
  end
  json.reviews deal.reviews(5) do |review|
    user = review.end_user
    json.user_name user.name || user.email
    json.review_text review.message
    json.rating review.rating.to_i
  end
end
json.status status
