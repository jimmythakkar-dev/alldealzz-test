class Api::V1::EndUsersController < Api::V1::BaseController
	before_action :end_user_authorize!

	def categories
    render_success(categories: DealCategory.all.map { |i| {cat_id: i.id, name: i.name} })
  end

  def set_categories
		categories_params = params[:categories] || []
    current_user.deal_categories = DealCategory.find(categories_params)
    current_user.is_categories_set = true
    render_success if current_user.save
	end

	def get_categories
    render_success(categories: current_user.deal_categories.map(&:id))
	end

	def index
    render_success(users: EndUser.all)
  end

  def notification_status
  	if params[:notif_status].present? && doorkeeper_token.update_attributes!(notification_status: params[:notif_status])
      render_success
    else
      render_error(417, "")
    end	
  end

  def add_feedback
  	if params[:message].present? && 
  		current_user.end_user_feedbacks.create(message: params[:message], contact: params[:contact])
      render_success
    else
      render_error(417, "")
    end	
  end
end