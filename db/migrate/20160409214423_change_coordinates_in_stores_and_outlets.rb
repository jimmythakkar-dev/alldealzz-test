class ChangeCoordinatesInStoresAndOutlets < ActiveRecord::Migration
  def up
  	rename_column :stores, :latitude, :xlatitude
  	rename_column :stores, :longitude, :xlongitude
  	rename_column :outlets, :latitude, :xlatitude
  	rename_column :outlets, :longitude, :xlongitude
  	(Store.all + Outlet.all).each do |i| 
  		i.geo_coordinate ||= GeoCoordinate.new(latitude: i.xlatitude, longitude: i.xlongitude)
  		i.geo_coordinate.save
  	end	
  end

  def down
  	rename_column :outlets, :xlongitude, :longitude
  	rename_column :outlets, :xlatitude, :latitude
  	rename_column :stores, :xlongitude, :longitude
  	rename_column :stores, :xlatitude, :latitude
  end
end
