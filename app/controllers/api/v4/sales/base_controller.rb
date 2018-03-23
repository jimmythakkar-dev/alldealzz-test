class Api::V4::Sales::BaseController < Api::V4::BaseController
  before_action :sales_user_authorize!

  def sales_user_store_authorize!
  	@stores = current_user.sales_user_stores
  	if [params[:store_id], params[:id]].any?
  	  @store = @stores.find_by_id(params[:store_id] || params[:id])
  	  render_error(401, 'You are not authorized to access this API.') unless @store
    end  
  end
end  