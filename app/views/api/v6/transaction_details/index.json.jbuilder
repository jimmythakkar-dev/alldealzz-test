json.total_count @transactions.total_count
json.transactions @transactions do |transaction|
  json.transaction_id transaction.id
  json.payment_status transaction.payment_status
  json.refunded transaction.refund?
  json.deal_title transaction.deal.main_line
  json.deal_quantity transaction.quantity
  json.total_amount transaction.total_amount
  json.date_time transaction.created_at.in_time_zone.strftime('%A, %d %b %Y at%l:%M%p')
end
json.status status
