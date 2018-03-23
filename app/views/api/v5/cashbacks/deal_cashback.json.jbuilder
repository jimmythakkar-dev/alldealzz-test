json.deal_cashbacks @cashbacks do |deal_cashback|
json.id deal_cashback.id
json.discount deal_cashback.discount.to_i.to_s + "% cashback" 
json.code deal_cashback.code
json.deal_id deal_cashback.deal_id if deal_cashback.cashback_type.eql?(1).present?
json.store_id deal_cashback.store_id if deal_cashback.cashback_type.eql?(2).present?
json.deal_category_id deal_cashback.deal_category_id if deal_cashback.cashback_type.eql?(3).present?
json.description deal_cashback.text
json.termsandconditions deal_cashback.termsandconditions.present? ? deal_cashback.termsandconditions.split("\r\n") : []
end
json.status status
