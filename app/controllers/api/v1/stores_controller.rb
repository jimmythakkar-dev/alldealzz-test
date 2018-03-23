class Api::V1::StoresController < Api::V1::BaseController
  before_action :end_user_authorize!

	def index
	  # render json: Store.all.to_json, status: :ok
    render_success(stores: stores_result)
	end

  def show
    render_success(store_result(Store.find(params[:id])))
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
    render_success(stores: favourites_stores_result)
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
    render_success(stores: follows_stores_result)
  end

  def interactive_map_stores
    @stores = nearby_stores_list
    render_success(template: :interactive_map_stores)
  end 

  private

  def stores_result
    lat = params[:latitude]
    lng = params[:longitude]

    return [] unless [lat, lng].all?

    stores = Store.allowed_stores
    stores_list_result(stores)  
  end

  def favourites_stores_result
    stores = current_user.favourite_stores
    stores_list_result(stores)
  end

  def follows_stores_result
    stores = current_user.follow_stores
    stores_list_result(stores)
  end

  def store_result(store)
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f

    return [] unless [lat, lng].all?

    {
      store_name: store.name,
      store_address: store.address,
      store_phone: store.contact_phone,
      is_following_store: current_user.follow_store?(store),
      is_user_like: current_user.favourite_store?(store),
      steps: store.steps(lat, lng),
      deals:  store_deals(store)
    }
  end


  def store_deals(store)
    deals = store.deals.click_notify_allowed_deals(nil, Deal::DealType[:rd])
    deals.map do |deal|
      {
        id: deal.id,
        description: deal.description,
        store_name: deal.store.name,
        title: deal.title,
        deal_photo: deal.deal_photo,
        store_photo: deal.store_photo,
        is_user_like: current_user.favourite_deal?(deal),
        category_id: deal.root_deal_category_id
      }
    end
  end

  def stores_list_result(stores)
    stores.map do |store|
      {
        store_id: store.id,
        store_name: store.name,
        no_of_deals: store.no_of_deals,
        store_photo: store.store_photo,
        store_from_mall: store.has_mall?,
        mall_name: store.mall_name
      }
    end
  end

  def nearby_stores_list
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
    category_id = params[:category_id]
    stores = []
    _deals = Deal.click_notify_enabled_deals
    
    if category_id.present?
      _deals = _deals.interested_deals([category_id.to_i])
    end
    
    sorted_deals = _deals.nearest_deals(lat,lng).each { |d| d.steps = d.store.steps(lat, lng) }.sort_floating(:steps)
    sorted_deals.map(&:store).uniq
  end  
end
