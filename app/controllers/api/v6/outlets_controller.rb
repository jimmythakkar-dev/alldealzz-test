class Api::V6::OutletsController < Api::V6::BaseController
  # before_action :end_user_authorize!

	def index
    @outlets = Store.find(params[:store_id]).outlets.outlet_status
    render_success(template: :index)
	end

  def show
    @outlet = Outlet.find(params[:id])

    store = @outlet.store
    @deals = store.store_deals("current").with_outlets.where('outlets.id = ?', @outlet)
    @upcoming_deals = store.store_deals("upcoming").with_outlets.where('outlets.id = ?', @outlet)
    @feeds = store.feeds.order("feed_type DESC")

    render_success(template: :show)
  end
end
