class GeoCoordinate < ActiveRecord::Base
  geocoded_by :address

  belongs_to :locationable, polymorphic: true
end
