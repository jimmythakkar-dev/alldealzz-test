deal = @deal
store = @store

json.data do
  json.id deal.id
  json.store_logo deal.store_photo
  json.store_id deal.store.id
  json.outlet_id store.has_outlets? ? @outlet.try(:id) : nil
  json.feature_image deal.featured_photo || deal.lmd_photo
  json.store_name deal.store.name
  json.store_locality store.has_outlets? ? @outlet.try(:locality) : store.locality
  json.is_following_store current_user.follow_store?(deal.store)
  json.is_deal_used current_user.deal_used?(deal)
  json.expiry_date deal.package_days.to_s + " days"
  json.deal_start_date deal.publish_date.to_date
  json.liked_by_user current_user.favourite_deal?(deal)
  json.unused_coupon_present @end_user_unused_coupon.present?
  json.is_expired deal.expired?
  json.price_flag deal.has_price?
  json.actual_price deal.price
  json.discounted_price deal.discounted_price
  json.share_text deal.share_text_url
  json.deal_type deal.deal_type_to_s
  json.approx_date_present deal.deal_type == 1 ? true : deal.approx_date_flag
  json.total_bought deal.total_bought
  json.total_left @total_left
  json.buyable_quantity_per_transaction deal.quantity_per_user.present? ? deal.quantity_per_user : -1
  json.internet_charges deal.internet_handling_charges.to_f
  json.details do
    json.main_line deal.title
    json.have_other_outlets store.has_outlets?
    json.avg_rating @avg_rating
    json.rating_count @rating_count
    json.description deal.description
    json.features deal.features.present? ? deal.features.split("\r\n") : []
    json.termsandconditions deal.termsandconditions.present? ? deal.termsandconditions.split("\r\n") : []
    json.have_more_deals @have_more_deals
    if @have_more_deals
      json.more_deals @other_deals do |other_deal|
        json.deal_id other_deal.id
        json.main_line other_deal.main_line
      end
    else
      json.more_deals []
    end
    if @is_last_minute_deal
      json.time_slots deal.lmd_time_slots.map { |i| i.strftime("%H:%M") }
    end
  end
  json.contact do
    if store.has_outlets? && @outlet
      json.store_phone @outlet.phone_number
      json.store_address @outlet.address
      json.latitude @outlet.latitude
      json.longitude @outlet.longitude
    else
      json.store_phone store.phone || store.contact_phone
      json.store_address store.address
      json.latitude store.latitude
      json.longitude store.longitude
    end
  end
  json.reviews @other_reviews do |review|
    user = review.end_user
    json.user_name user.name || user.email
    json.review_text review.message
    json.rating review.rating.to_i
    json.profile_photo user.profile_photo
  end
  if @current_user_review.present?
    json.my_review do
      json.review_id @current_user_review.id
      json.review_text @current_user_review.message
      json.rating @current_user_review.rating.to_i
    end
  else
    json.my_review nil
  end
  json.otp_status current_user.otp_status
  json.phone_verified current_user.phone_verified?
  # Remove in next update
  json.has_coupon false
  json.coupon_text @coupon_code
  json.is_coupon_used true
end
json.status status
