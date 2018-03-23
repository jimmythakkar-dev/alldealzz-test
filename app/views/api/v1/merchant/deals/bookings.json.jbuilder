json.total_count @deals.total_count
json.partial! 'deals', deals: @deals
json.status status
