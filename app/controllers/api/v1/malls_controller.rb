class Api::V1::MallsController < Api::V1::BaseController
  before_action :end_user_authorize!
  
  def index
    render_success({ malls: malls_result })
  end

  def show
    render_success(mall_result(Mall.find(params[:id])))
  end

  def follow
    mall = Mall.find(params[:id])
    follow = mall.end_user_follow_malls.where(end_user: current_user)
    if follow.blank? 
      follow = mall.end_user_follow_malls.new(end_user: current_user)
      render_success if follow.save!
    else
      render_success if follow.destroy_all
    end
  end

  def follows
    render_success({ malls: follows_malls_result })
  end 

  private

  def malls_result
    lat = params[:latitude]
    lng = params[:longitude]

    return [] unless [lat, lng].all?

    malls = Mall.allowed_malls
    malls_list_result(malls)
  end

  def follows_malls_result
    malls = current_user.follow_malls
    malls_list_result(malls)
  end

  def malls_list_result(malls)
    malls.map do |mall|
      {
        mall_id: mall.id,
        mall_name: mall.name,
        no_of_stores: mall.no_of_stores,
        mall_logo: mall.mall_logo
      }
    end
  end
  
  # Only allowed stores are taken in response.
  def mall_result(mall)
    lat = params[:latitude]
    lng = params[:longitude]
    stores = mall.stores.allowed_stores

    {
      mall_name: mall.name,
      mall_address: mall.address,
      steps: mall.steps(lat, lng),
      stores: stores_list_result(stores)
    }
  end

  def stores_list_result(stores)
    stores.map do |store|
      {
        store_id: store.id,
        store_name: store.name,
        no_of_deals: store.no_of_deals,
        store_photo: store.store_photo,
        store_from_mall: store.has_mall?
      }
    end
  end
end
