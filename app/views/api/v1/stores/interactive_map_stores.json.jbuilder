json.stores @stores do |store|
  json.store_id store.id
  json.store_name store.name
  json.lat store.latitude
  json.lng store.longitude
end
json.status status
