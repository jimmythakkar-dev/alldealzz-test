class Api::V5::DealsController < Api::V5::BaseController
  before_action :end_user_authorize!, except: [:index, :sponsored_deals, :get_deal_sub_categories]
  before_action :get_deal_resource, only: [:show, :reviews, :add_review, :my_review,
    :edit_review, :add_favourite, :use, :booking_code, :booking_code_with_otp]

  def index
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f

    # TODO : Inappropriate
    doorkeeper_token.update_location(lat, lng) rescue false

    @deals = deals_result(lat, lng).page(params[:page]).per(10)
    @deals.each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }
    render_success(template: :index)
  end

  def upcoming_deals
    params[:deals_type] = "upcoming"
    index
  end

  def categorised_upcoming_deals
    index
  end

  # TODO : only for enabled / allowed deals ?
  def show
    @days = @deal.days.present? ? @deal.days.split(",") : []
    @deal.create_click_analytics(current_user)
    @total_store_deals = @deal.store.store_deals("current")
    if @deal.outlet_ids.present?
      if (params[:outlet_id].present? && params[:outlet_id] != "(null)")
        @outlet = Outlet.find(params[:outlet_id])
      else
        @outlet = Outlet.find(@deal.outlet_ids.last)
      end
      outlet_deals = @total_store_deals.with_outlets.where('outlets.id = ?', @outlet)
    end
    end_user_deals = @deal.end_user_used_deals.where('end_user_id = ? and booking_code_id is not null', current_user)
    @end_user_unused_coupon = end_user_deals.where('used_status = ?', false)
    @end_user_used_coupon = end_user_deals.where('used_status = ?', true)
    @coupon_code = @end_user_unused_coupon.present? ? @end_user_unused_coupon.first.booking_code.coupon_code : nil
    @total_store_deals = outlet_deals if outlet_deals.present?
    @have_more_deals = @total_store_deals.to_a.count > 1 ? true : false
    @other_deals = []
    if @have_more_deals
      @other_deals = @total_store_deals.reject {|deal| deal.id == @deal.id}
    end
    @is_last_minute_deal = @deal.is_last_minute_deal?
    reviews = @deal.end_user_deal_reviews
    @rating_count = reviews.count
    @review_count = reviews.where.not(message: [nil, '']).count
    @avg_rating =  @rating_count > 0 ? (reviews.map(&:rating).sum/@rating_count.to_f).round(1) : nil
    @current_user_review = @deal.reviews.where(end_user_id: current_user.id).last
    @other_reviews = @deal.reviews(5).where('end_user_id != ?',current_user.id)
      @total_left = (@deal.total_left < 0 || @deal.total_bought == 0 && @deal.total_left == 0) ? -1 : @deal.total_left
    render_success(template: :show)
  end

  # TODO : only for enabled / allowed deals ?
  def reviews
    @deal_reviews = @deal.reviews.where('end_user_id != ?',current_user.id).page(params[:page]).per(10)
    render_success(template: :reviews)
  end

  def my_review
    @my_review = @deal.reviews.where(end_user_id: current_user.id).last
    render_success(template: :my_review)
  end

  def add_review
    review = @deal.end_user_deal_reviews.new(end_user: current_user, message: params[:review],
                                            rating: params[:rating].to_f)
    render_success if review.save!
  end

  def edit_review
    end_user_reviewed_deal = @deal.reviews.where(end_user_id: current_user.id).last
    end_user_reviewed_deal.message = params[:review_text]
    end_user_reviewed_deal.rating = params[:rating].to_i
    render_success if end_user_reviewed_deal.save!
  end

  def add_favourite
    favourite = @deal.end_user_favourites.where(end_user: current_user)
    if favourite.blank?
      favourite = @deal.end_user_favourites.new(end_user: current_user)
      render_success if favourite.save!
    else
      render_success if favourite.destroy_all
    end
  end

  def use
    self_redeemed_deal = BookingCode.find(params[:booking_code_id]).end_user_used_deal
    render_success if self_redeemed_deal.present? && self_redeemed_deal.update_attribute('used_status', true)
    user = self_redeemed_deal.end_user
    begin
      if self_redeemed_deal.transaction_detail.present? 
        transaction_detail = self_redeemed_deal.transaction_detail
        if transaction_detail.cashback_id.present?
          cashback_detail = Cashback.find_by(id: transaction_detail.cashback_id)
          cashback_points = cashback_detail.points.round(2)
          if cashback_points.present?
            end_user_reward_points = EndUserRewardPoint.find_by(end_user_id: user.id)
            if end_user_reward_points.present?
              if cashback_points >= transaction_detail.percentage_off
                end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + transaction_detail.percentage_off)
                EndUserPointsHistory.create(end_user_id: user.id, points: transaction_detail.percentage_off, cashback_id: cashback_detail.id, deal_id: self_redeemed_deal.deal_id, history_points_type: 0)
              else
                end_user_reward_points.update_attributes(points: end_user_reward_points.points.round(2) + cashback_points.round(2))
                EndUserPointsHistory.create(end_user_id: user.id, points: cashback_points.round(2), cashback_id: cashback_detail.id, deal_id: self_redeemed_deal.deal_id, history_points_type: 0)
              end
            else
              if cashback_points >= transaction_detail.percentage_off
                end_user_reward_points = EndUserRewardPoint.create(end_user_id: user.id, points: transaction_detail.percentage_off)
                EndUserPointsHistory.create(end_user_id: user.id, points: transaction_detail.percentage_off, cashback_id: cashback_detail.id, deal_id: self_redeemed_deal.deal_id, history_points_type: 0)
              else
                end_user_reward_points = EndUserRewardPoint.create(end_user_id: user.id, points: cashback_points.round(2))
                EndUserPointsHistory.create(end_user_id: user.id, points: cashback_points.round(2), cashback_id: cashback_detail.id, deal_id: self_redeemed_deal.deal_id, history_points_type: 0)
              end
            end
          end
        end
      end
    rescue => e
    end
  end

  def favourites
    @deals = current_user.favourite_deals.with_unexpired_deal.page(params[:page]).per(10)
    render_success(template: :favourites)
  end

  def booked_deals
    used_deals = if params[:deal_type] == "paid"
      current_user.end_user_used_deals.book_deals.joins(:transaction_detail).joins(:deal).where("transaction_details.payment_status = ? AND deals.deal_type  in (?)",TransactionDetail::PaymentStatus[:success], [Deal::DealType[:pd], Deal::DealType[:lmd]]).group("end_user_used_deals.id")
    else
      current_user.end_user_used_deals.book_deals.joins(:deal).where("deals.deal_type not in (?)", [Deal::DealType[:pd], Deal::DealType[:lmd]]).group("end_user_used_deals.id")
    end
    @end_user_used_deals = used_deals.order('created_at DESC').page(params[:page]).per(10)
    render_success(template: :booked_deals)
  end

  def get_deal_sub_categories
    category_id = params[:category_id].to_i
    @sub_categories = DealCategory.where(:sub_deal_category_id => category_id)
    render_success(template: :get_deal_sub_categories)
  end

  def booking_code(with_otp = false)
    if params[:email].present?
      current_user.update_attributes(email: params[:email], otp_verified: false, otp_requested: false)
    end
    if current_user.errors.present?
      render_error(422, current_user.errors.full_messages.to_sentence)
    elsif @deal.expired?
      render_error(422, "Sorry, this deal has expired")
    elsif with_otp && !current_user.otp_verified?
      render_success(otp_status: current_user.otp_requested? ? 2 : 3)
    elsif @deal.exceeded_booking_limit?(current_user)
      render_error(422, "You have booked this deal max number of times")
    elsif (booking_code = @deal.create_booking_code(params[:outlet_id], current_user, { id: params[:transaction_id], payu_id: params[:payu_id] }, params[:booking_details])).present?
      render_success(otp_status: 1, coupon_code: booking_code.coupon_code, 
        message: "Congratulations, You have successfully booked this Deal!!")
    else
      render_error(422, "Sorry, This deal cannot be booked. To get this deal, Please update or download the latest version of our app.")
    end
  end

  def sponsored_deals
    @deals = Deal.sponsored_deals.click_notify_allowed_deals(current_user_city, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd], Deal::DealType[:lmd], Deal::DealType[:ced], Deal::DealType[:cedb]])
    render_success(template: :sponsored_deals)
  end

  private

  # Filters are: type
  # 1-Popular
  # 2-Best Seller
  # 3-View Count
  # 4-Nearby(default)
  def deals_result(lat, lng)
    category_ids = params[:category_id]
    city_filter = current_user_city
    type = [1,2,3,4,5].include?(params[:type].to_i) ? params[:type].to_i : 4
    type = 5 if params[:deals_type] == "upcoming"
    _deals = if type == 5
      Deal.click_notify_allowed_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd], Deal::DealType[:ced], Deal::DealType[:cedb]]).created_month_ago(2)
    else
      Deal.click_notify_allowed_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd], Deal::DealType[:ced], Deal::DealType[:cedb]])
    end

    if category_ids.present?
      _deals = _deals.interested_deals(category_ids)
    end
    
    case type
    when 1
      _deals.popular_deals
    when 2
      _deals.best_seller_deals
    when 3
      _deals.view_count_deals.created_month_ago(2)
    when 5
      _deals.order('created_at DESC')
    else
      # sorted_deals = _deals.nearest_deals(lat,lng,3).each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }.sort_floating(:steps)
      # Kaminari.paginate_array(sorted_deals).page(params[:page]).per(10)
      _deals.with_locations.nearest(lat,lng)
    end
  end

  def get_deal_resource
    @deal = Deal.find(params[:id])
    @store = @deal.store
  end
end
