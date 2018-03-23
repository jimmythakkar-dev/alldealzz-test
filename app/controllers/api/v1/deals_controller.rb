class Api::V1::DealsController < Api::V1::BaseController
	before_action :end_user_authorize!

	def index
    @deals = deals_result
	  render_success(template: :index)
	end

  def categorised_deals
    @deals = deals_result
    render_success(template: :categorised_deals)
  end

	def show
    @deal = Deal.find(params[:id])
    @deal.create_click_analytics(current_user)
    render_success(template: :show)   
	end

	def reviews
    @deal = Deal.find(params[:id])
    render_success(template: :reviews)
	end
  
	def add_review
    deal = Deal.find(params[:id])
    review = deal.end_user_deal_reviews.new(end_user: current_user, message: params[:review], 
      rating: params[:rating].to_f)
    render_success if review.save!
	end

	def add_favourite
    deal = Deal.find(params[:id])
    favourite = deal.end_user_favourites.where(end_user: current_user)
    if favourite.blank? 
      favourite = deal.end_user_favourites.new(end_user: current_user)
      render_success if favourite.save!
    else
      render_success if favourite.destroy_all
    end    
	end

  def use
    deal = Deal.find(params[:id])
    used = deal.end_user_used_deals.where(end_user: current_user)
    if used.blank? 
      used = deal.end_user_used_deals.new(end_user: current_user)
      render_success if used.save!
    else
      render_success if used.destroy_all
    end   
  end

  def favourites
    @deals = current_user.favourite_deals
    render_success(template: :favourites)
  end

  # Not used in mobile 
  def used_deals
    @deals = current_user.used_deals
    render_success(template: :used_deals)
  end

  private
  
  # Filters are: type
  # 1-Popular
  # 2-Best Seller
  # 3-View Count
  # 4-Nearby(default)
  def deals_result
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
    category_id = params[:category_id]
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 4
    
    _deals = Deal.click_notify_allowed_deals(nil, Deal::DealType[:rd])
    
    if category_id.present?
      _deals = _deals.interested_deals([category_id.to_i])
    end

    case type
    when 1
      _deals.popular_deals.created_month_ago(2).page(params[:page]).per(10).each { |d| d.steps = d.store.steps(lat, lng) }
    when 2
      _deals.best_seller_deals.created_month_ago.page(params[:page]).per(10).each { |d| d.steps = d.store.steps(lat, lng) }
    when 3
      _deals.view_count_deals.created_month_ago.page(params[:page]).per(10).each { |d| d.steps = d.store.steps(lat, lng) }
    else
      # Removed nearest deals filter
      # sorted_deals = _deals.each { |d| d.steps = d.store.steps(lat, lng) }.sort_floating(:steps)
      # Kaminari.paginate_array(sorted_deals).page(params[:page]).per(10)
      _deals.with_locations.nearest(lat, lng).page(params[:page]).per(10).each { |d| d.steps = d.store.steps(lat, lng) }
    end
  end
end
