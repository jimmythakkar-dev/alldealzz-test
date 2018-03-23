class Api::V4::MembershipTransactionDetailsController < Api::V4::BaseController
  before_action :end_user_authorize!
  before_action :get_membership_plan_resource, except: [:update_membership_status]

  def new
    @gateway_id = params[:gateway_id].present? ? params[:gateway_id].to_i : 2
    @transaction = @membership_plan.membership_transaction_details.create(end_user_id: current_user.id)

    if @transaction.present?
      render_success(template: :new)
    else
      render_error(400, "Bad Request")
    end
  end

  def update_membership_status
    @transaction = MembershipTransactionDetail.find_by_id(params[:transaction_id])
    payment_status = params[:payment_status].to_i
    if payment_status == 1 && @transaction.update_attributes(payment_status: payment_status, payu_id: params[:payu_id])
      membership_expiry_date = Time.zone.now.to_date + ClubMembershipDetail::PlanType[@transaction.club_membership_detail_id]
      current_user.update_attributes(club_membership_detail_id: @transaction.club_membership_detail_id, membership_expiry_date: membership_expiry_date)
    else
      @transaction.update_attributes(payment_status: payment_status)
    end
    render_success(is_club_member: current_user.is_club_member?)
  end


  private

  def get_membership_plan_resource
    @membership_plan = ClubMembershipDetail.find(params[:plan_id])
  end
end