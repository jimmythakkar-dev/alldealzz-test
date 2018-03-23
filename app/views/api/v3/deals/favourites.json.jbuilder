json.total_count @deals.total_count
json.partial! 'deals', deals: @deals, steps: false
json.status status
