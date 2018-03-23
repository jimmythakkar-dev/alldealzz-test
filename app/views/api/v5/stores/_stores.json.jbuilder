json.stores stores do |store|
	json.store_id store.id
  json.store_name store.name
  json.has_outlets store.has_outlets?
  json.sub_items_count store.has_outlets? ? store.outlets.count : store.no_of_deals
  json.store_photo store.store_photo
  json.store_from_mall store.has_mall?
  json.mall_name store.mall_name
  json.item_type store.item_type_and_count[:item_type].pluralize(store.item_type_and_count[:item_count])
  json.item_count store.item_type_and_count[:item_count]
end
