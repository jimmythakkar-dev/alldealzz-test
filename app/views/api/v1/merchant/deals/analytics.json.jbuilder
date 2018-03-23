json.analytics @analytics_count do |data|
  json.date data[:date].strftime("%d-%m-%Y")
  json.count data[:count]
end
json.status status