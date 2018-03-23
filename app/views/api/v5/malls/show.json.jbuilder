lat = params[:latitude].to_f
lng = params[:longitude].to_f

json.mall_name @mall.name
json.mall_address @mall.address
json.steps @mall.steps(lat, lng)
json.stores @stores do |store|
  json.store_id store.id
  json.store_name store.name
  json.sub_items_count store.has_outlets? ? store.outlets.count : store.no_of_deals
  json.store_photo store.store_photo
  json.store_from_mall store.has_mall?
end
json.status status
