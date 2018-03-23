transaction = @transaction_detail

json.transaction_id transaction.id
# json.payment_status TransactionDetail::PaymentStatus.key(transaction.payment_status)
json.settlement_amount @settlement_amount #1,5
json.commission_amount @commission_amount #2
json.service_tax 0.to_s #3
json.deal_amount @deal_amount #4,6
json.internet_handling @internet_handling #7
json.gross_amount @gross_amount #8
json.deal_quantity @quantity
json.order_date transaction.created_at.strftime('%a, %d %b %Y')
json.bank_ref_id transaction.bank_ref_id
# json.payu_id transaction.payu_id
# json.settlement_status TransactionDetail::PaymentStatus.key(transaction.settlement_status)
# json.settlement_date_time transaction.settlement_date && transaction.settlement_date.strftime('%A, %d %b %Y at%l:%M%p')
json.status status
