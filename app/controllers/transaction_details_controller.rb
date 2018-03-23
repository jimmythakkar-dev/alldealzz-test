class TransactionDetailsController < ApplicationController
	load_and_authorize_resource
  before_action :get_resource, only: [:settlement, :unsettlement]

  def index
    transaction_details = if params[:search].present?
      if (search_text = params[:search][:text]).present?
        condtions = ['lower(transaction_details.payu_id) like ?', "%#{search_text.downcase}%"]
      end
      case params[:search][:selected]
        when 's_success'
          @transaction_details.successfull_settlement
        when 's_redeemed'
          @transaction_details.used_only_deals.no_full_commission_deals.unsettled
        when 'all'
          @transaction_details.successful_payment
        else
          @transaction_details.successful_payment.pending_settlement.no_full_commission_deals
        end
    else
      @transaction_details.successful_payment.pending_settlement.no_full_commission_deals
    end

    @transaction_details = transaction_details.where(condtions)
      .order('created_at desc').page(params[:page]).per(10)
  end

  def edit
    @transaction_detail.settlement_date = Date.today
  end

  def update
    respond_to do |format|
        if params[:transaction_detail][:refund] == "1"
          @points_refund = @transaction_detail.end_user_points_history
          @points_refund.update_attributes(history_points_type: 2)
        end
      if @transaction_detail.update(transaction_detail_params)
        format.html { redirect_to transaction_details_path, notice: 'Transaction detail was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def settlement
    @transaction_detail.settlement_status = TransactionDetail::SettlementStatus[:success]
    @transaction_detail.settlement_date ||= Date.today
    
    @transaction_detail.save
    # MerchantMailer.send_payment_merchant(@transaction_detail.get_email).deliver_now
    render :show
  end

  def unsettlement
    @transaction_detail.settlement_status = TransactionDetail::SettlementStatus[:pending]
    @transaction_detail.settlement_date = nil

    @transaction_detail.save
    render :show
  end

  private

  def get_resource
      @transaction_detail = TransactionDetail.find(params[:id])
    end
    
  def transaction_detail_params
      params.require(:transaction_detail).permit(:settlement_date, :bank_ref_id,
        :settlement_status, :refund, :cashback_id, :points)
    end
end
