class Api::V1::Merchant::BaseController < Api::V1::BaseController
  before_action :merchant_user_authorize!

  def merchant_user_store_authorize!
  	@store = current_user.store
    @deals = current_user.merchantable.deals

  	unless @store.present?
  	  render_error(401, 'You are not authorized to access this API.')
    end  
  end
end  