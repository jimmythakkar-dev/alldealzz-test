class EndUserRewardPoint < ActiveRecord::Base
	belongs_to :end_user
	has_many :end_user_points_histories
end
