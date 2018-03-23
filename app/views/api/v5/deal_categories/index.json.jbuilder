json.data do
  json.normal_categories @normal_categories do |category|
    json.id category.id
    json.name category.name
    json.priority_order category.priority_order
    json.icon_url category.category_photo
  end

  json.lmd_categories @lmd_categories do |category|
    json.id category.id
    json.name category.name
    json.priority_order category.priority_order
    json.icon_url category.category_photo
  end
end
json.status status