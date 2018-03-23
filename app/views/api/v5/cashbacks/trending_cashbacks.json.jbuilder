json.cashbacks @trending_cashbacks do |cashback|
	expires = cashback.expiry_date.to_date - Time.zone.now.to_date
json.id cashback.id
json.description cashback.text
json.cashback_type cashback.cashback_type
if cashback.cashback_type.eql?(1).present?
	json.deal_id cashback.deal_id 
	json.deal_type cashback.deal.deal_type_to_s
end
json.discount cashback.discount.to_i.to_s + "% cashback" 
json.code cashback.code
json.expiry_days expires.to_i 
if Rails.env == "development"
    if cashback.cashback_image.present?
    json.image "http://" + request.host_with_port + cashback.cashback_image
    else
    json.image  cashback.cashback_image
  end
  else
    json.image  cashback.cashback_image
  end
json.termsandconditions cashback.termsandconditions.present? ? cashback.termsandconditions.split("\r\n") : []
end
json.status status