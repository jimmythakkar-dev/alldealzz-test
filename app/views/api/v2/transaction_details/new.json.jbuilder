json.data do
  json.payu_api_key Settings.payu.key
  json.payu_salt Settings.payu.salt
  json.transaction_id @transaction.id
  json.redirect_url Settings.payu.redirect_url
end
json.status status
