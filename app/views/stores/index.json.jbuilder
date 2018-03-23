json.array!(@stores) do |store|
  json.extract! store, :id, :name, :phone, :city, :latitude, :longitude, :radius, :address, :contact_phone, :contact_persone, :status, :location, :store_category_id,:referral_code
  json.url store_url(store, format: :json)
end
