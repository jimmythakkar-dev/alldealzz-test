json.deals deals do |deal|
  store = deal.store
  nearest_outlet = store.nearest_outlet(deal, params[:latitude], params[:longitude])
  reminder = current_user.deal_reminder(deal)
  json.id deal.id
  json.store_name store.name
  json.title deal.title
  json.feature_image deal.featured_photo || deal.lmd_photo
  json.store_photo deal.store_photo
  json.locality nearest_outlet.present? ? nearest_outlet.locality : store.locality
  json.price_flag deal.has_price?
  json.actual_price deal.price.to_i
  json.discounted_price deal.discounted_price.to_i
  if steps.present?
    json.steps (deal.steps/3.28) #Temporary to show correct steps in iOS
    json.outlet_id nearest_outlet.try(:id)
  end
  json.is_expired deal.expired?
  if deal.expired?
    json.minutes deal.live_time_difference
  else
    json.minutes deal.lmd_time_difference.hour*60 + deal.lmd_time_difference.strftime("%M").to_i
  end
  json.is_reminder_set reminder.present?
  json.reminder_id reminder.id if reminder.present?
  json.coupons deal.total_left
  json.time_difference deal.lmd_time_difference.strftime("%H:%M") # remove in v6
  json.category_id deal.try(:deal_category_ids).try(:first)
  json.cashback_flag deal.cashback_discount.present?
  json.cashback_discount deal.cashback_discount.to_i.to_s + "% cashback" if deal.cashback_discount.present?
end
