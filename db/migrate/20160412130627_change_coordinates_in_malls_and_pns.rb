class ChangeCoordinatesInMallsAndPns < ActiveRecord::Migration
  def up
  	rename_column :malls, :latitude, :xlatitude
  	rename_column :malls, :longitude, :xlongitude
  	rename_column :premium_notifications, :latitude, :xlatitude
  	rename_column :premium_notifications, :longitude, :xlongitude
  	(Mall.all + PremiumNotification.all).each do |i| 
  		i.geo_coordinate ||= GeoCoordinate.new(latitude: i.xlatitude, longitude: i.xlongitude)
  		i.geo_coordinate.save
  	end	
  end

  def down
  	rename_column :premium_notifications, :xlongitude, :longitude
  	rename_column :premium_notifications, :xlatitude, :latitude
  	rename_column :malls, :xlongitude, :longitude
  	rename_column :malls, :xlatitude, :latitude
  end
end
