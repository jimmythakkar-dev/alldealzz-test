json.stores @stores do |store|
  json.store_id store.id
  json.store_name store.name
  json.latitude store.latitude
  json.longitude store.longitude
end
json.status status
