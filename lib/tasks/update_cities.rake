namespace :update_cities do
  task :all => [:end_user, :city_stores, :mall]

  desc "To update city in End users"
  task end_user: :environment do
    EndUser.update_all(city_id: 1)
    puts "=> Updated all end users with city_id 1"
  end

  desc "To update city in Stores"
  task city_stores: :environment do
    Store.find_each do |store|
      city = store.city
      if city.present? && store.current_city.blank?
        city_id = City.where(name: city).first.id rescue City.first.id
        store.update_attributes(city_id: city_id)
        puts "=> Updated: #{store.name}"
      end
    end
  end

  desc "To update city in Malls"
  task mall: :environment do
    Mall.find_each do |mall|
      city = mall.city
      if city.present? && mall.current_city.blank?
        city_id = City.where(name: city).first.id rescue City.first.id
        mall.update_attributes(city_id: city_id)
        puts "=> Updated: #{mall.name}"
      end
    end
  end
end
