module Distanceable
  extend ActiveSupport::Concern
	# include ActionView::Helpers

  included do
    has_one :geo_coordinate, as: :locationable
    accepts_nested_attributes_for :geo_coordinate

    scope :with_locations, -> { joins(:geo_coordinate) }

	  # Default distance is 1.5 miles
	  # Options 
	  #   :units = :mi or :km
	  scope :in_distance, ->(lat, lng, distance = 1.5, options = {}) {
	    center_point = [lat, lng]
	    if center_point.all?
	      box = Geocoder::Calculations.bounding_box(center_point, distance, options)
	      # enabled.within_bounding_box(box)
        with_locations.where('geo_coordinates.latitude BETWEEN ? AND ? AND geo_coordinates.longitude BETWEEN ? AND ?',box[0],box[2],box[1],box[3])
	    end  
	  }
  end

  # In meter
  # Options 
  #   :mode = :walking, :driving
  #
  # Some more helps :
  # step_miles = Geocoder::Calculations.distance_between([lat,lng], [latitude, longitude])
  # "#{(5280 * step_miles).to_i} Steps"
  def steps(lat, lng, options = { mode: :walking })
    lat, lng = lat.to_f, lng.to_f
    if latitude.present? and longitude.present?
	    
      options[:origins] = "#{lat},#{lng}"
      options[:destinations] = "#{latitude},#{longitude}"
      
      step_meter = begin
      	# Google api distance
      	url = "https://maps.googleapis.com/maps/api/distancematrix/json?#{URI.encode_www_form(options)}"
        res = JSON.parse(RestClient.get(url), {:accept => :json})
        res["rows"][0]["elements"][0]["distance"]["value"]
      rescue Exception => e
      	# Direct distance : converted from miles to meter
        distance_from([lat,lng]) * 1609.34 
      end
      # In step
      # number_to_human((3.28 * step_meter).to_i, precision: 2)
      
      step_meter ? step_meter.to_i : nil
	  end  
  end

  # Default checking is in miles
  # currently is in :km
  def in_radius?(lat, lng, distance = nil)
    return false unless ([lat,lng].all? && (radius.present? || distance.present?))
    distance_from([lat,lng], :km) <= ( distance ? distance : radius )
  end

  def latitude
    geo_coordinate.try(:latitude)
  end

  def longitude
    geo_coordinate.try(:longitude)
  end
end