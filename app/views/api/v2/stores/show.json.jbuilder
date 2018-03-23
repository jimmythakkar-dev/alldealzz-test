lat = params[:latitude].to_f
lng = params[:longitude].to_f

json.store_name @store.name
json.store_locality @store.locality
json.store_phone @store.phone || @store.contact_phone
json.is_following_store current_user.follow_store?(@store)
json.steps @store.steps(lat, lng)

json.deals @deals do |deal|
  json.id deal.id
	json.title deal.title
	json.deal_photo deal.deal_photo
	json.liked_by_user current_user.favourite_deal?(deal)
  json.price_flag deal.has_price?
  json.actual_price deal.price.to_i
  json.discounted_price deal.discounted_price.to_i
  json.deal_type deal.deal_type_to_s
end

json.upcoming_deals @upcoming_deals do |deal|
  json.id deal.id
	json.title deal.title
	json.deal_photo deal.deal_photo
	json.liked_by_user current_user.favourite_deal?(deal)
  json.price_flag deal.has_price?
  json.actual_price deal.price.to_i
  json.discounted_price deal.discounted_price.to_i
  json.deal_type deal.deal_type_to_s
end

json.status status
