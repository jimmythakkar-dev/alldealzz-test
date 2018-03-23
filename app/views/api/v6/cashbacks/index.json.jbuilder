json.cashbacks @cashbacks do |cashback|
	expires = cashback.expiry_date.to_date - Time.zone.now.to_date
	json.title cashback.deal.store.name if cashback.cashback_type.eql?(1).present?
	json.title cashback.store.name if cashback.cashback_type.eql?(2).present?
	json.id cashback.id
	json.steps cashback.steps if cashback.steps.present?
	json.description cashback.text
	json.cashback_type cashback.cashback_type
	json.store_id cashback.store_id if cashback.cashback_type.eql?(2).present?
	json.deal_id cashback.deal_id if cashback.cashback_type.eql?(1).present?
	if cashback.cashback_type.eql?(3).present?
		category = cashback.deal_category
		json.category_id cashback.deal_category_id 
		json.category_type category.deal_type
		json.category_name category.name
		json.title "All #{category.name} Deals" 
	end
	json.deal_type cashback.deal.deal_type if cashback.cashback_type.eql?(1).present? # NOTE : Changed deal_type_to_s to deal_type
	json.discount cashback.discount.to_i.to_s + "% cashback" 
	json.code cashback.code
	json.expiry_days expires.to_i 
	json.termsandconditions cashback.termsandconditions.present? ? cashback.termsandconditions.split("\r\n") : []
end
json.status status