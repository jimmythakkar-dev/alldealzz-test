json.array!(@deal_categories) do |deal_category|
  json.extract! deal_category, :id, :name
  json.url store_deal_category_url(@store, deal_category, format: :json)
end
