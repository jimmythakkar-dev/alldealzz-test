json.data do
  if @gateway_id.eql?(2)
    json.payu_api_key Settings.payu.key
    json.payu_salt Settings.payu.salt
    json.transaction_id @transaction.id
    json.redirect_url Settings.payu.redirect_url
  elsif @gateway_id.eql?(3)
    json.publishable_key Settings.stripe.publishable_key
  else
    json.transaction_id @transaction.id
    json.customer_id "AD" + current_user.id.to_s
    json.merchant_id Settings.paytm.merchant_id
    json.chksum_generate_url Settings.paytm.chksum_generate_url
    json.chksum_verify_url Settings.paytm.chksum_verify_url
    json.channel_id Settings.paytm.channel_id
    json.industry_type_id Settings.paytm.industry_type_id
    json.website Settings.paytm.website
  end
end
json.status status
