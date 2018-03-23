json.deals deals do |deal|
  store = deal.store

  json.id deal.id
  json.store_name store.name
  json.title deal.title
  json.feature_image deal.featured_photo
  json.deal_photo deal.deal_photo
  json.store_photo deal.store_photo
  json.locality store.locality
  json.price_flag deal.has_price?
  json.actual_price deal.price.to_i
  json.discounted_price deal.discounted_price.to_i
  json.liked_by_user current_user.favourite_deal?(deal)
  if steps.present?
    json.steps deal.steps
    json.outlet_id store.nearest_outlet(deal, params[:latitude], params[:longitude]).try(:id)
  end
  json.is_expired deal.expired?

  json.coupons deal.remaining_last_coupons
  json.time_difference deal.lmd_time_difference.strftime("%H:%M")
end
