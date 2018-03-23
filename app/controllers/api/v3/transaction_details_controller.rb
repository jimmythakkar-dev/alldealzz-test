class Api::V3::TransactionDetailsController < Api::V3::BaseController
  before_action :end_user_authorize!
  before_action :get_deal_resource, except: [:index]

  def new
    if @deal.exceeded_booking_limit?(current_user)
      render_error(422, "You have bought this deal max number of times")
    else
      @transaction = @deal.create_transaction_detail(current_user,
        { quantity: params[:deal_quantity], total_amount: params[:total_amount], outlet_id: params[:outlet_id] })
      if @transaction.present?
        render_success(template: :new)
      else
        render_error(400, "Bad Request")
      end
    end
  end

  def index
    @transactions = current_user.transaction_details.order('id DESC').page(params[:page]).per(10)
    render_success(template: :index)
  end

  private

  def get_deal_resource
    @deal = Deal.find(params[:deal_id])
    # @store = @deal.store
  end
end