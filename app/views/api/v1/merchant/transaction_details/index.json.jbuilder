json.total_count @transaction_details.total_count
json.partial! 'transaction_details', transaction_details: @transaction_details
json.status status
