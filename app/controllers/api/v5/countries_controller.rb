class Api::V5::CountriesController < Api::V5::BaseController

  def index
    @countries = Country.all.map do |country|
      {
          id: country.id,
          name: country.name,
          icon_url: country.logo_url,
          isd_code: Rails.env == "development" ? '+91' : country.isd_code,
          server_url: Rails.env == "development" ? (country.id == 1 ? 'http://192.168.2.100:1234' : 'http://192.168.2.101:1234') : country.server_url,
          currency: country.id == 1 ? "\u20b9" : "\u00a3"
      }
    end
    if params[:latitude].present? && params[:longitude].present?
      geo_localization = "#{params[:latitude]},#{params[:longitude]}"
      query = Geocoder.search(geo_localization).first
      country = Country.find_by(name: query.try(:country))
      if country.present?
        @countries = [@countries.find {|c| c[:name] == country.name}]
      end
    end
    render_success(countries: @countries)
  end
end
