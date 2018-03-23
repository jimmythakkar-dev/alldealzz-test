namespace :update_end_user_subscribed_cities do
	desc "create end_user_subscribed_city"
	task create_end_user_subscribed_city: :environment do
		EndUser.transaction do
			EndUser.all.find_in_batches(start: 1, batch_size: 5) do |end_user|
				end_user.each do |user|
					city_id = user.city_id
					end_user_id = user.id 
					if city_id.present?
						end_user_subscribed_city = EndUserSubscribedCity.find_or_create_by(end_user_id: end_user_id, city_id: city_id)
						puts "=> Updated end_user_subscribed_city =  end_user_id: #{end_user_subscribed_city.end_user_id}, city_id: #{end_user_subscribed_city.city_id}"
					else
						end_user_subscribed_city = EndUserSubscribedCity.find_or_create_by(end_user_id: end_user_id, city_id: 1)
						puts "=> Updated end_user_subscribed_city "
					end
				end
			end
		end
	end
end