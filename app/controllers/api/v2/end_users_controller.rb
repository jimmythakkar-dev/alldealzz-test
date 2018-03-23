class Api::V2::EndUsersController < Api::V2::BaseController
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

  def update_city
    city_id = params[:city_id]
    if current_user.update_attributes(city_id: city_id)
      render_success
    else
      render_error(422, current_user.errors.full_messages.to_sentence)
    end
  end
end