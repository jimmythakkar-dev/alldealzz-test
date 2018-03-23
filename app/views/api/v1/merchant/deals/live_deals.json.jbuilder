json.total_count @deals.total_count
json.partial! 'live_past_deals', deals: @deals
json.status status
