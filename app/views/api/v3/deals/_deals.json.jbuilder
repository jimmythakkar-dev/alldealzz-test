json.deals deals do |deal|
  store = deal.store
  
  json.id deal.id
  json.store_name store.name
  json.title deal.title
  json.deal_photo deal.deal_photo
  json.price_flag deal.has_price?
  json.actual_price deal.price
  json.discounted_price deal.discounted_price
  if steps.present?
    json.steps deal.steps
    json.outlet_id store.nearest_outlet(deal, params[:latitude], params[:longitude]).try(:id)
   end
  json.store_photo deal.store_photo
  json.liked_by_user current_user.favourite_deal?(deal)
  json.category_id deal.root_deal_category_id
  json.is_expired deal.expired?
  json.deal_type deal.deal_type_to_s
end