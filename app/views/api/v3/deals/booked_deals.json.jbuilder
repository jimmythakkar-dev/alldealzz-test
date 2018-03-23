json.total_count @end_user_used_deals.total_count
json.deals @end_user_used_deals do |end_user_deal|
  deal = end_user_deal.deal

  json.id end_user_deal.deal_id
  json.store_name deal.store.name
  json.title deal.title
  json.is_expired deal.expired?
  json.booking_code end_user_deal.booking_code.coupon_code
  json.booking_code_id end_user_deal.booking_code_id
  json.booked_date end_user_deal.created_at.strftime('%a, %d %b %Y')
  if end_user_deal.transaction_detail.present?
    json.paid_amount end_user_deal.transaction_detail.total_amount.to_s
    json.total_quantity end_user_deal.transaction_detail.quantity
  end
  json.redeem_status end_user_deal.status
end
json.status status
