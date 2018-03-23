class Api::V2::DealsController < Api::V2::BaseController
  before_action :end_user_authorize!
  before_action :get_deal_resource, only: [:show, :reviews, :add_review,
    :edit_review, :add_favourite, :use, :booking_code, :booking_code_with_otp]

  def index
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f

    # TODO : Inappropriate
    doorkeeper_token.update_location(lat, lng)

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
    @deal.create_click_analytics(current_user)
    @total_store_deals = @deal.store.store_deals("current")
    if @store.has_outlets? && (params[:outlet_id].present? && params[:outlet_id] != "(null)")
      @outlet = Outlet.find(params[:outlet_id])
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
    @avg_rating =  @rating_count > 0 ? (reviews.map(&:rating).sum/@rating_count.to_f).round(1) : nil
    @current_user_review = @deal.reviews.where(end_user_id: current_user.id).last
    @other_reviews = @deal.reviews(5).where('end_user_id != ?',current_user.id)
    @total_left = (@deal.total_left < 0 || @deal.total_bought == 0 && @deal.total_left == 0) ? -1 : @deal.total_left
    render_success(template: :show)
  end

  # TODO : only for enabled / allowed deals ?
  def reviews
    @deal_reviews = @deal.reviews.where('end_user_id != ?',current_user.id)
    render_success(template: :reviews)
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

  ## TODO : Needs to be changed for multiple deals to be booked
  def use
    used = @deal.end_user_used_deals.where(end_user: current_user, used_status: false)
    used.present? && used.first.update_attribute('used_status', true)
    render_success(is_reviewed: current_user.deal_reviewed?(@deal))
  end

  def favourites
    @deals = current_user.favourite_deals.with_unexpired_deal.page(params[:page]).per(10)
    render_success(template: :favourites)
  end

  def booked_deals
    used_deals = if params[:deal_type] == "paid"
      current_user.used_deals.with_deal_type([Deal::DealType[:pd], Deal::DealType[:lmd]]).with_success_full_payment
    else
      current_user.used_deals.without_deal_type([Deal::DealType[:pd], Deal::DealType[:lmd]])
    end
    @deals = used_deals.unredeemed_deals.page(params[:page]).per(10)
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

  def booking_code_with_otp
    booking_code(with_otp = true)
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
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 4

    _deals = if params[:deals_type] == "upcoming"
      Deal.click_notify_upcoming_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd]])
    else
      Deal.click_notify_allowed_deals(city_filter, [Deal::DealType[:rd], Deal::DealType[:ed], Deal::DealType[:pd]])
    end

    if category_ids.present?
      _deals = _deals.interested_deals(category_ids)
    end
    
    case type
    when 1
      _deals.popular_deals.created_month_ago(2)
    when 2
      _deals.best_seller_deals.created_month_ago
    when 3
      _deals.view_count_deals.created_month_ago
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
