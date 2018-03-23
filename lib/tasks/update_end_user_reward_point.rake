namespace :update_end_user_reward_points do
	desc "create end_user_reward_point"
	task create_end_user_reward_point: :environment do
		EndUser.transaction do
			EndUser.all.find_in_batches(start: 1, batch_size: 500) do |end_user|
				end_user.each do |user|
					end_user_id = user.id 
					if end_user_id.present?
						end_user_reward_point = EndUserRewardPoint.find_or_create_by(end_user_id: end_user_id, points: 50)
						puts "=> Updated end_user_reward_point =  end_user_id: #{end_user_reward_point.end_user_id}"
					end
				end
			end
		end
	end
end