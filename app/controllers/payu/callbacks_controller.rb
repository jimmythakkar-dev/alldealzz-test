class Payu::CallbacksController < ApplicationController
  skip_before_filter :verify_authenticity_token
  def deal_payment
  	# TODO : Explore callbacks & booking calls
  	#
		# if params[:status].present? && params[:status] == 'success' && params[:mihpayid].present? &&
		#    (td = TransactionDetail.find_by_id(params[:id])).present?
		#    td.update_attributes(payment_status: 1, payu_id: params[:mihpayid])
		#    td.end_user_used_deal.update_attributes({ booking_code_id: booking_code.id }.merge(booking_details))
		#  else

    render layout: false
  end
end
