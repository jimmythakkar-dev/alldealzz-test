json.data do
  json.normal_categories @normal_categories do |category|
    json.id category.id
    json.name category.name
  end

  json.lmd_categories @lmd_categories do |category|
    json.id category.id
    json.name category.name
  end
end
json.status status