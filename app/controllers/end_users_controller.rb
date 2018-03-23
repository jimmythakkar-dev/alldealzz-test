class EndUsersController < ApplicationController
	load_and_authorize_resource
	before_filter :get_resource, only: [ :edit, :show, :update, :points]
	
	def index
		end_users = EndUser.all
		if params[:search].present?
			search_text = params[:search][:text]
			condtions = ['lower(end_users.name) like ? or end_users.phone_number like ?', "%#{search_text.downcase}%", "%#{search_text.downcase}%" ]
		end
		@end_users = end_users.where(condtions).order('created_at desc').page(params[:page]).per(25)
	end
	
	def show
		@end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: current_user.id)
	end
	
	def points
		if @end_user.end_user_reward_point.present?
			@end_user_reward_points = @end_user.end_user_reward_point
		else
			@end_user_reward_points = EndUserRewardPoint.find_or_create_by(end_user_id: @end_user.id)
		end
	end
	
	def add_points
		@end_user_reward_points = @end_user.end_user_reward_point
		if @end_user_reward_points.points.present?
			@end_user_reward_points.update_attributes(points: @end_user_reward_points.points.round(2) + params[:end_user_reward_point][:points].to_f.round(2))
			@end_user_points_histories = EndUserPointsHistory.create(end_user_id: @end_user.id, user_id: current_user.id, points: params[:end_user_reward_point][:points].to_f.round(2), history_points_type: 0)
		else
			 @end_user_reward_points.update_attributes(points: params[:end_user_reward_point][:points].to_f)
			 @end_user_points_histories = EndUserPointsHistory.create(end_user_id: @end_user.id, user_id: current_user.id, points: params[:end_user_reward_point][:points].to_f.round(2), history_points_type: 0)
		end
		 redirect_to points_end_user_path(@end_user), notice: 'end_user points was successfully updated.'
	end
	
	def block_user
		if @end_user.black_listed == false
			@end_user.oauth_access_tokens.destroy_all
			@sucess = @end_user.update_attributes(black_listed: true)
		else
			@sucess = @end_user.update_attributes(black_listed: false)
		end
		redirect_to end_user_path(@end_user)
	end
	
	private
	
	def get_resource
		@end_user = EndUser.find(params[:id])
	end

end
