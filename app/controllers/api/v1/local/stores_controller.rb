class Api::V1::Local::StoresController < Api::V1::Local::BaseController
	def index
    render_success(stores: deals_result)
	end

  private

  def deals_result
    lat = params[:latitude]
    lng = params[:longitude]

    return [] unless [lat, lng].all?

    stores = Store.allowed_stores.in_distance(lat, lng, 10, units: :km)
    stores_list_result(stores)  
  end

  def stores_list_result(stores)
    stores.map do |store|
      {
        store_id: store.id,
        latitude: store.latitude,
        radius: store.radius,
        longitude: store.longitude
      }
    end
  end
end
