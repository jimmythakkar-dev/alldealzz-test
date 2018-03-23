class Api::V4::EndUserSubscribedCitiesController < Api::V4::BaseController
  before_action :end_user_authorize!

  def index
    cities = City.where.not(id: 4).sort.map do |city|
      {
          id: city.id,
          name: city.name,
          subscribed: current_user.end_user_subscribed_cities.map(&:city_id).include?(city.id)
      }
    end
    render_success(subscribed_cities: cities)
  end

  def update_cities
    subscribed_cities_params = params[:subscribed_cities] || []
    current_user.end_user_subscribed_cities.destroy_all
    subscribed_cities_params.each do |city_id|
      EndUserSubscribedCity.create(end_user_id: current_user.id, city_id: city_id)
    end
    render_success if current_user.save
  end
end
