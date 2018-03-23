class Api::V1::Merchant::TransactionDetailsController < Api::V1::Merchant::BaseController
  before_action :merchant_user_store_authorize!
  
  # NOTE : settlement_status is settled, unsettled
  def index
    @transaction_details = Kaminari
      .paginate_array(current_user.transaction_details(params[:settlement_status]))
      .page(params[:page]).per(10)
    render_success(template: :index)
  end

  def show
    @transaction_detail = TransactionDetail.find(params[:id])
    @deal = @transaction_detail.deal
    @quantity = @transaction_detail.quantity
    @settlement_amount = @deal.settlement_amount(@quantity)
    @commission_amount = @deal.commission_amount(@quantity)
    @deal_amount = @settlement_amount + @commission_amount
    @internet_handling = @deal.internet_handling(@quantity)
    @gross_amount = @deal_amount + @internet_handling
    render_success(template: :show)   
	end
end
