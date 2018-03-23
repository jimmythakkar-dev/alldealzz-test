class Api::V4::ExclusiveDealsController < Api::V4::BaseController
	before_action :end_user_authorize!

	def index
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f

    @deals = deals_result(lat, lng).page(params[:page]).per(10)
    @deals.each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }
	  render_success(template: :index)
	end

  private
  
  # Filters are: type
  # 1-Popular
  # 2-Best Seller
  # 3-View Count
  # 4-Nearby(default)
  def deals_result(lat, lng)
    category_ids = params[:category_id]
    city_filter = current_user_city
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 4
    _deals = Deal.click_notify_allowed_deals(city_filter, [Deal::DealType[:ced], Deal::DealType[:cedb]])
    if category_ids.present?
      _deals = _deals.interested_deals(category_ids)
    end

    case type
    when 1
      _deals.popular_deals
    when 2
      _deals.best_seller_deals
    when 3
      _deals.view_count_deals
    else
      _deals.with_locations.nearest(lat,lng)
    end
  end
end
