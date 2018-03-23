class Api::V5::StoresController < Api::V5::BaseController
  before_action :end_user_authorize!, except: [:index, :show]

	def index
    @stores = stores_result.page(params[:page]).per(10)
    render_success(template: :index)
	end

  def show
    @store = Store.find(params[:id])
    @deals = @store.store_deals("current")
    @feeds = @store.feeds.order("feed_type DESC")

    render_success(template: :show)
  end

  def add_favourite
    store = Store.find(params[:id])
    favourite = store.end_user_favourite_stores.where(end_user: current_user)
    if favourite.blank? 
      favourite = store.end_user_favourite_stores.new(end_user: current_user)
      render_success if favourite.save!
    else
      render_success if favourite.destroy_all
    end
  end

  def favourites
    @stores = current_user.favourite_stores.page(params[:page]).per(10)
    render_success(template: :index)
  end

  def follow
    store = Store.find(params[:id])
    follow = store.end_user_follow_stores.where(end_user: current_user)
    if follow.blank? 
      follow = store.end_user_follow_stores.new(end_user: current_user)
      render_success if follow.save!
    else
      render_success if follow.destroy_all
    end    
  end

  def follows
    @stores = current_user.follow_stores.allowed_stores.page(params[:page]).per(10)
    render_success(template: :index)
  end

  def interactive_map_stores
    @stores = nearby_stores_list
    render_success(template: :interactive_map_stores)
  end

  def brand_stores
    @stores = Store.brand_only_store(current_user_city).page(params[:page]).per(10)
    render_success(template: :index)
  end

  private

  def stores_result
    city_filter = current_user_city || params[:city]
    Store.allowed_stores(city_filter)
  end

  def nearby_stores_list
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
    if params[:category_id].present?
      category_id = params[:category_id]
    else
      category_id = DealCategory.find_by(priority_order: 1, deal_type: 0).try(:id) || DealCategory.first.try(:id)
    end
    _deals = Deal.click_notify_enabled_deals
    if category_id.present?
      _deals = _deals.interested_deals([category_id.to_i])
    end

    sorted_deals = _deals.nearest_deals(lat,lng).each { |d| d.steps = d.store.steps(lat, lng) }.sort_floating(:steps)
    sorted_deals.map(&:store).uniq 
  end  
end
