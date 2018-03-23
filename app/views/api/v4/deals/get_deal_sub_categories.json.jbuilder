sub_categories = @sub_categories

if @sub_categories
  json.sub_categories sub_categories do |sub_category|
    json.sub_category_id sub_category.id
    json.name sub_category.name
  end
else
  json.sub_categories []
end