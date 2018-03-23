class Api::V2::Local::StoresController < Api::V2::Local::BaseController
	def index
    render_success(stores: deals_result, outlets: outlets_result)
	end

  private

  def deals_result
    lat = params[:latitude]
    lng = params[:longitude]

    return [] unless [lat, lng].all?

    stores = Store.allowed_stores.in_distance(lat, lng, 10, units: :km)
    stores_list_result(stores)  
  end

  def outlets_result
    lat = params[:latitude]
    lng = params[:longitude]

    return [] unless [lat, lng].all?

    outlets = Outlet.allowed_outlets.in_distance(lat, lng, 10, units: :km)
    outlets_list_result(outlets)  
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

  def outlets_list_result(outlets)
    outlets.map do |outlet|
      {
          outlet_id: outlet.id,
          latitude: outlet.latitude,
          radius: outlet.radius,
          longitude: outlet.longitude
      }
    end
  end
end
