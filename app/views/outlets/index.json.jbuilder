json.array!(@outlets) do |outlet|
  json.extract! outlet, :id, :address, :latitude, :longitude, :locality, :location,:phone_number,:contact_phone,:contact_person, :status
  json.url store_outlet_url(@store, outlet, format: :json)
end
