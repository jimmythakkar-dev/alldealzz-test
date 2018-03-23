json.deals deals do |deal|
  store = deal.store
  total_left = (deal.total_left < 0 || deal.total_bought == 0 && deal.total_left == 0) ? -1 : deal.total_left
  json.id deal.id
  json.store_name store.name
  json.title deal.title
  if sponsored
    json.deal_photo deal.sponsored_deal_photo
  else
    json.deal_photo deal.deal_photo
  end
  json.price_flag deal.has_price?
  json.actual_price deal.price
  json.discounted_price deal.discounted_price
  json.total_bought deal.total_bought
  json.total_left total_left
  if steps.present?
    json.steps deal.steps
    json.outlet_id store.nearest_outlet(deal, params[:latitude], params[:longitude]).try(:id)
   end
  json.store_photo deal.store_photo
  json.liked_by_user current_user.favourite_deal?(deal) rescue false
  json.category_id deal.root_deal_category_id
  json.is_expired deal.expired?
  if deal.expired?
    json.minutes deal.live_time_difference
  else
    json.minutes deal.lmd_time_difference.hour*60 + deal.lmd_time_difference.strftime("%M").to_i
  end
  json.deal_type deal.deal_type_to_s
  json.cashback_flag deal.cashback_discount.present?
  json.cashback_discount deal.cashback_discount.to_i.to_s + "% cashback" if deal.cashback_discount.present?
end
