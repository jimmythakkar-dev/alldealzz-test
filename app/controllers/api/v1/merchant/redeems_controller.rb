class Api::V1::Merchant::RedeemsController < Api::V1::Merchant::BaseController
  before_action :merchant_user_store_authorize!
  
  def deal
    code = params[:redeem_code].strip.upcase
    ## TODO commenting because outlet_id is not passed from iOS app, hence codes are not getting redeemed currently when booked from iOS
    #booking_code = current_user.booking_codes.where(coupon_code: code, redeemed: false).first

    booking_code = BookingCode.where(coupon_code: code, redeemed: false).first
    redeemed_code = BookingCode.where(coupon_code: code, redeemed: true).first
    if booking_code.present?
      self_redeemed = booking_code.end_user_used_deal.used_status
      end_user_used_deal = booking_code.redeemed_deal
      @deal = end_user_used_deal.used_deal
      user = end_user_used_deal.end_user
      begin
        if end_user_used_deal.transaction_detail.present? && !self_redeemed
          transaction_detail = end_user_used_deal.transaction_detail
          if transaction_detail.cashback_id.present?
            cashback_detail = Cashback.find_by(id: transaction_detail.cashback_id)
            cashback_points = cashback_detail.points.round(2)
            if cashback_points.present?
              end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: user.id)
              if end_user_reward_points.present?
                if cashback_points >= transaction_detail.percentage_off
                  end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + transaction_detail.percentage_off)
                  EndUserPointsHistory.create(end_user_id: user.id, points: transaction_detail.percentage_off, cashback_id: cashback_detail.id, deal_id: @deal.id, history_points_type: 0)
                else
                  end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + cashback_points.round(2))
                  EndUserPointsHistory.create(end_user_id: user.id, points: cashback_points.round(2), cashback_id: cashback_detail.id, deal_id: @deal.id, history_points_type: 0)
                end
              else
                if cashback_points >= transaction_detail.percentage_off
                  end_user_reward_points = EndUserRewardPoint.create(end_user_id: user.id, points: transaction_detail.percentage_off)
                  EndUserPointsHistory.create(end_user_id: user.id, points: transaction_detail.percentage_off, cashback_id: cashback_detail.id, deal_id: @deal.id, history_points_type: 0)
                else
                  end_user_reward_points = EndUserRewardPoint.create(end_user_id: user.id, points: cashback_points.round(2))
                  EndUserPointsHistory.create(end_user_id: user.id, points: cashback_points.round(2), cashback_id: cashback_detail.id, deal_id: @deal.id, history_points_type: 0)
                end
              end
            end
          end
        end
      rescue => e
      end
      @customer_name = user.name
      @deal_quantity = end_user_used_deal.try(:transaction_detail).try(:quantity)
      if @deal.present?
        # NOTE : @merchant_user & @booking_cod used in deal.js.erd
        @merchant_user = current_user
        @booking_code = booking_code
        if request.xhr?
          render_success(template: :deals)
        else
          render_success(template: :deal)

        end
      else
        render_error(404, 'This Deal has expired or is invalid')
      end
    elsif redeemed_code.present?
      render_error(404, 'This code has already been redeemed')
    else
      render_error(404, 'Invalid Code')
    end
  end

  def code
    @deal = @store.deal.first
    render_success(template: :code)
  end

  ## Todo Remove from here create controller concern
  def get_deal_sub_categories
    category_id = params[:category_id].to_i
    @sub_categories = DealCategory.where(:sub_deal_category_id => category_id)
    render_success(template: :get_deal_sub_categories)
  end
end
