class Api::V2::MallsController < Api::V2::BaseController
  before_action :end_user_authorize!
  
  def index
    @malls = malls_result.page(params[:page]).per(10)
    render_success(template: :index)
  end

  def show
    @mall = Mall.find(params[:id])
    @stores = @mall.stores.allowed_stores

    render_success(template: :show)
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
    @malls = current_user.follow_malls.page(params[:page]).per(10)
    render_success(template: :index)
  end 

  private

  def malls_result
    Mall.allowed_malls(current_user_city)
  end
end
