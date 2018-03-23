namespace :populate_cities do
  desc "Insert/Update Cities"
  task insert_cities: :environment do
    Store::Cities.each do |city|
      City.find_or_create_by(name: city)
      puts "=> Created: #{city}"
    end
  end
end