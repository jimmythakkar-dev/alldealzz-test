json.array!(@deal_categories) do |deal_category|
  json.extract! deal_category, :id, :name, :priority_order, :logo_image
  json.url store_deal_category_url(@store, deal_category, format: :json)
end
