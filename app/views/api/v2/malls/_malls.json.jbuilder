json.malls malls do |mall|
  json.mall_id mall.id
  json.mall_name mall.name
	json.no_of_stores mall.no_of_stores
	json.mall_logo mall.mall_logo
end
