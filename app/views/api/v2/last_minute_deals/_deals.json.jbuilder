json.deals deals do |deal|
  store = deal.store
  nearest_outlet = store.nearest_outlet(deal, params[:latitude], params[:longitude])

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

  json.coupons deal.total_left
  json.time_difference deal.lmd_time_difference.strftime("%H:%M")
end
