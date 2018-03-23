class Api::V4::VoucherCodeDetailsController < Api::V4::BaseController
  before_action :end_user_authorize!

  def check_voucher_code
    voucher_code = params[:voucher_code].strip.upcase
    @voucher_code = VoucherCodeDetail.find_by(code: voucher_code)

    if @voucher_code.present? && @voucher_code.status?
      render_error(422, 'This Voucher Code has already been used')
    elsif @voucher_code.present? && !@voucher_code.status?
      @voucher_code.update_attributes(status: true)
      membership_expiry_date = Time.zone.now.to_date + ClubMembershipDetail::PlanType[@voucher_code.club_membership_detail_id]
      current_user.update_attributes(voucher_code_detail_id: @voucher_code.id, club_membership_detail_id: @voucher_code.club_membership_detail_id, membership_expiry_date: membership_expiry_date)
      render_success(is_club_member: current_user.is_club_member?, message: "Voucher Code Applied Successfully")
    else
      render_error(422, 'Please enter a valid voucher code')
    end
  end

end