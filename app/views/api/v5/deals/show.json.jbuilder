deal = @deal
store = @store
featured_photo = deal.featured_photo
lmd_photo = deal.lmd_photo
reminder = current_user.deal_reminder(deal)

json.data do
  json.id deal.id
  if Rails.env == "development"
    if deal.store_photo.present?
     json.store_logo "http://" + request.host_with_port + deal.store_photo
    else
     json.store_logo  deal.store_photo
    end
  else
    json.store_logo  deal.store_photo
  end
  json.store_id deal.store.id
  json.outlet_id deal.outlet_ids.present? ? @outlet.try(:id) : nil
  if Rails.env == "development"
    if featured_photo.present?
      json.feature_image "http://" + request.host_with_port + deal.featured_photo 
    elsif lmd_photo.present?
      json.feature_image "http://" + request.host_with_port + deal.lmd_photo
    else
     json.feature_image deal.featured_photo || deal.lmd_photo
   end
  else
   json.feature_image featured_photo || lmd_photo
  end
  image_array = []
  deal.deal_detail_images.each do |pic|
    if Rails.env == "development"
      image_array << "http://" + request.host_with_port + pic.image.url
    else 
      image_array << pic.image.url
    end
  end
  json.deal_detail_images (image_array.present? ? image_array : ([featured_photo].compact || [lmd_photo].compact))
  json.store_name deal.store.name
  json.store_locality store.has_outlets? ? @outlet.try(:locality) : store.locality
  json.is_following_store current_user.follow_store?(deal.store)
  json.is_deal_used current_user.deal_used?(deal)
  json.expiry_date deal.package_days.to_s + " days"
  json.deal_start_date deal.publish_date.to_date
  json.liked_by_user current_user.favourite_deal?(deal)
  json.unused_coupon_present @end_user_unused_coupon.present?
  json.is_expired deal.expired?
  json.is_club_member current_user.is_club_member?
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
  json.valid_days @days
  json.deal_category_id deal.deal_categories.root_categories.first.id if deal.deal_categories.present?
  json.timings_flag @deal.display_timings
  json.start_time @deal.last_start_time.strftime("%H:%M")
  json.end_time @deal.last_end_time.strftime("%H:%M")
  json.valid_for_people @deal.valid_for
  json.appointment_text @deal.appointment_mandatory? ? "Reservation or Prior Appointment Mandatory" : nil
  json.cashback_flag deal.cashback_discount.present?
  json.cashback_discount deal.cashback_discount.to_i.to_s + "% cashback" if deal.cashback_discount.present?
  json.details do
    json.main_line deal.title
    json.have_other_outlets store.has_outlets?
    json.avg_rating @avg_rating
    json.rating_count @rating_count
    json.review_count @review_count
    json.description deal.description
    json.features deal.features.present? ? deal.features.split("\r\n") : []
    json.termsandconditions deal.termsandconditions.present? ? deal.termsandconditions.split("\r\n") : []
    json.have_more_deals @have_more_deals
    if @have_more_deals
      json.more_deals @other_deals do |other_deal|
        json.deal_id other_deal.id
        json.store_name other_deal.store.name
        json.title other_deal.title
        json.main_line other_deal.title
        json.deal_type other_deal.deal_type_to_s
        json.liked_by_user current_user.favourite_deal?(other_deal)
        json.total_bought other_deal.total_bought
        json.price_flag other_deal.has_price?
        json.actual_price other_deal.price
        json.discounted_price other_deal.discounted_price
        if Rails.env == "development"
          if other_deal.featured_photo.present?  
            json.deal_photo "http://" + request.host_with_port + other_deal.featured_photo 
          elsif other_deal.lmd_photo.present?
            json.deal_photo "http://" + request.host_with_port + other_deal.lmd_photo
          else
            json.deal_photo other_deal.featured_photo || other_deal.lmd_photo
         end
       else
        json.deal_photo other_deal.featured_photo || other_deal.lmd_photo
       end
        json.cashback_flag other_deal.cashback_discount.present?
        json.cashback_discount other_deal.cashback_discount.to_i.to_s + "% cashback" if other_deal.cashback_discount.present?
        json.steps other_deal.store.sorted_outlet_steps(other_deal, params[:latitude], params[:longitude])
        if other_deal.is_last_minute_deal?
          json.is_expired other_deal.expired?
          if other_deal.expired?
            json.minutes other_deal.live_time_difference
          else
            json.minutes other_deal.lmd_time_difference.hour*60 + other_deal.lmd_time_difference.strftime("%M").to_i
          end
          json.time_difference other_deal.lmd_time_difference.strftime("%H:%M")
        end
      end
    else
      json.more_deals []
    end
    if @is_last_minute_deal
      json.time_slots deal.lmd_time_slots.map { |i| i.strftime("%H:%M") }
      json.time_difference deal.lmd_time_difference.strftime("%H:%M")
      
      if deal.expired?
        json.minutes deal.live_time_difference
      else
        json.minutes deal.lmd_time_difference.hour*60 + deal.lmd_time_difference.strftime("%M").to_i
      end
      json.is_reminder_set reminder.present?
      json.reminder_id reminder.id if reminder.present?
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
