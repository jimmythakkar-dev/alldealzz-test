deal = @deal

json.customer_name @customer_name
json.title deal.title
json.deal_type deal.deal_type_to_s
json.expires_on deal.package_days.to_s + " Days"
json.features deal.features.present? ? deal.features.split("\r\n") : []
json.terms_and_conditions deal.termsandconditions.present? ? deal.termsandconditions.split("\r\n") : []
json.deal_quantity @deal_quantity

json.status status

      
