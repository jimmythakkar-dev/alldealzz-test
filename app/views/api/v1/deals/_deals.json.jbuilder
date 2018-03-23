json.deals deals do |deal|
  json.id deal.id
  json.store_name deal.store.name
  json.title deal.title
  json.deal_photo deal.deal_photo
  if steps.present?
    json.steps deal.steps
  end
  json.store_photo deal.store_photo
  json.is_user_like current_user.favourite_deal?(deal)
  json.category_id deal.root_deal_category_id
  json.is_expired deal.expired?
end
