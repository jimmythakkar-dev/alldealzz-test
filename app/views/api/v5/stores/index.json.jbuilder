json.total_count @stores.total_count
json.partial! 'stores', stores: @stores
json.status status
