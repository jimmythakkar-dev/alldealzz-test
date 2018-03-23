json.transaction_details transaction_details do |transaction|
  json.transaction_id transaction.id
  # json.payment_status TransactionDetail::PaymentStatus.key(transaction.payment_status)
  # json.deal_title transaction.deal.main_line
  # json.deal_quantity transaction.quantity
  json.settlement_amount transaction.deal.settlement_amount(transaction.quantity)
  json.order_date transaction.created_at.strftime('%a, %d %b %Y')
  if transaction.end_user_used_deal.try(:self_redeemed_at).present? 
  json.due_date (transaction.end_user_used_deal.try(:self_redeemed_at) + 7.days).strftime('%a, %d %b %Y') rescue false
  elsif transaction.end_user_used_deal.try(:booking_code).try(:redeemed_at).present?
  json.due_date (transaction.end_user_used_deal.try(:booking_code).try(:redeemed_at) + 7.days).strftime('%a, %d %b %Y') rescue false
  else
  json.due_date (transaction.created_at + 7.days).strftime('%a, %d %b %Y')
  end
  json.settlement_id transaction.bank_ref_id
  # json.payu_id transaction.payu_id
  # json.settlement_status TransactionDetail::PaymentStatus.key(transaction.settlement_status)
  json.settlement_date transaction.settlement_date.strftime('%a, %d %b %Y') if transaction.settlement_date.present?
end
