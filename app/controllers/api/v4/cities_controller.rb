class Api::V4::CitiesController < Api::V4::BaseController
  before_action :end_user_authorize!

  def index
    cities = City.where.not(id: 4).sort.map do |city|
      {
          id: city.id,
          name: city.name,
          icon_url: city.icon_url
      }
    end
    render_success(cities: cities, message: 'We are not operational in this city, Yet!')
  end
end
