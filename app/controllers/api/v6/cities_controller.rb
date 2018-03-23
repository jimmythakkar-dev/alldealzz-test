class Api::V6::CitiesController < Api::V6::BaseController
  before_action :end_user_authorize!

  def index
    cities = City.all.sort.map do |city|
      {
          id: city.id,
          name: city.name,
          icon_url: city.icon_url
      }
    end
    render_success(cities: cities, message: 'We are not operational in this city, Yet!')
  end
end
