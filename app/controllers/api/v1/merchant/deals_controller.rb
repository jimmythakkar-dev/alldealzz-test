class Api::V1::Merchant::DealsController < Api::V1::Merchant::BaseController
  before_action :merchant_user_store_authorize!
  before_action :deal_resource, only: [:update, :show_booking, :analytics]

  def create
    # NOTE : Adding outlet in deal if merchantable is outlet
    if current_user.merchantable.is_a?(Outlet)
      params[:outlet_ids] = [current_user.merchantable.id]
    end
    @deal = @store.deals.new(deal_params)
    @deal.deal_categories = update_deal_categories
    is_with = deal_live_with_approval?(@deal)
    @deal.commission_percent = @store.lmd_commission_percent if @deal.is_last_minute_deal?
    if params[:deal][:percent_lmd].present? && params[:deal][:percent_lmd] == "true" && is_with.present?
      @deal.price = 1
      @deal.discounted_price = 1
      @deal.commission_percent = 100
    end
    if @deal.save_as_approval(is_with)
      # Send notification
      send_lmd_notifications if is_with.present? and params[:deal][:send_notification].blank?
      render_success(message: 'Deal Created Successfully')
    else
      render_error(422, @deal.errors.full_messages.to_sentence)
    end
  end

  def update
    @deal.deal_categories = update_deal_categories
    is_with = deal_live_with_approval?(@deal)

    if @deal.update_as_approval(is_with, deal_params)
      render_success(message: 'Deal Updated Successfully')
    else
      render_error(422, @deal.errors.full_messages.to_sentence)
    end
  end

  def bookings
    @deals = @deals.enabled_deals.order('created_at desc').page(params[:page]).per(10)
    render_success(template: :bookings)
  end

  def show_booking
    @bookings = @deal.booking_holders.order('created_at desc').page(params[:page]).per(10)
    render_success(template: :show_booking)
  end

  def live_deals
    @deals = @deals.with_unexpired_deal.page(params[:page]).per(10)
    render_success(template: :live_deals)
  end

  def past_deals
    @deals = @deals.with_expired_deal.page(params[:page]).per(10)
    render_success(template: :past_deals)
  end

  def analytics
    from_date = params[:from_date].present? ? params[:from_date].to_date : 1.week.ago.in_time_zone.to_date
    end_date = params[:end_date].present? ? params[:end_date].to_date : Date.today.in_time_zone.to_date
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 1
    @analytics_count = []
    (from_date .. end_date).each do |day|
      day_counts = case type
      when 1
        @deal.deal_analytics.where("DATE(created_at) = :day", { day: day }).count
      when 2
        @deal.end_user_favourites.where("DATE(created_at) = :day", { day: day }).count
      when 3
        @deal.pushed_notifications.where(sent: true).where("DATE(created_at) = :day", { day: day }).count
      when 4
        @deal.end_user_used_deals.where("booking_code_id is not null AND DATE(created_at) = :day", { day: day }).count
      end
      @analytics_count.push({ date: day, count: day_counts })
    end
    render_success(template: :analytics)
  end

  def follower_analytics
    from_date = params[:from_date].present? ? params[:from_date].to_date : 1.week.ago.in_time_zone.to_date
    end_date = params[:end_date].present? ? params[:end_date].to_date : Date.today.in_time_zone.to_date
    @analytics_count = []
    (from_date .. end_date).each do |day|
      day_counts = current_user.store.end_user_follow_stores.where("DATE(created_at) <= :day", { day: day }).count
      @analytics_count.push({ date: day, count:  day_counts })
    end
    render_success(template: :analytics)
  end

  def get_deal_categories
    @normal_categories = DealCategory.root_categories.with_deal_type(0)
    @lmd_categories = DealCategory.root_categories.with_deal_type(1)
    render_success(template: :get_deal_categories)
  end

  def pie_chart_analytics
    from_date = params[:from_date].to_date 
    end_date = params[:end_date].to_date
    type = [1,2,3,4].include?(params[:type].to_i) ? params[:type].to_i : 1
    @analytics_count = []
    @analytics_count = case type
    when 1
      @age_counts = [{age_slots: "17-24", count: DealAnalytic.date_report(from_date, end_date).age_1.count },{ age_slots: "24-30",count: DealAnalytic.date_report(from_date, end_date).age_2.count },{ age_slots: "30+", count: DealAnalytic.date_report(from_date, end_date).age_3.count },{ age_slots: "Not specified", count: DealAnalytic.date_report(from_date, end_date).age_4.count}]
      @gender_counts = {male: DealAnalytic.date_report(from_date, end_date).male.count, female: DealAnalytic.date_report(from_date, end_date).female.count, gender_not_specifed: DealAnalytic.date_report(from_date, end_date).not_specifed.count }
    when 2
      @age_counts = [{age_slots: "17-24", count: EndUserFavourite.date_report(from_date, end_date).age_1.count }, { age_slots: "24-30",count: EndUserFavourite.date_report(from_date, end_date).age_2.count },{ age_slots: "30+", count: EndUserFavourite.date_report(from_date, end_date).age_3.count },{age_slots: "Not specified", count: EndUserFavourite.date_report(from_date, end_date).age_4.count}]
      @gender_counts = {male: EndUserFavourite.date_report(from_date, end_date).male.count,female: EndUserFavourite.date_report(from_date, end_date).female.count, gender_not_specifed: EndUserFavourite.date_report(from_date, end_date).not_specifed.count }
    when 4
      @age_counts = [{age_slots: "17-24", count: EndUserUsedDeal.date_report(from_date, end_date).age_1.count }, { age_slots: "24-30",count: EndUserUsedDeal.date_report(from_date, end_date).age_2.count },{ age_slots: "30+", count: EndUserUsedDeal.date_report(from_date, end_date).age_3.count }, { age_slots: "Not specified", count: EndUserUsedDeal.date_report(from_date, end_date).age_4.count}]
      @gender_counts = { male: EndUserUsedDeal.date_report(from_date, end_date).male.count, female: EndUserUsedDeal.date_report(from_date, end_date).female.count, gender_not_specifed: EndUserUsedDeal.date_report(from_date, end_date).not_specifed.count}
    end
    # @age_counts = [{age_slots: "17-24", count: 5 },{ age_slots: "24-30",count: 6 },{ age_slots: "30+", count: 7 },{ age_slots: "Not specified", count: 4}]
      # @gender_counts = {male: 10, female: 11, gender_not_specifed: 1 }
    render_success(template: :pie_chart_analytics)
  end
  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def deal_params
    params[:deal][:days] = params[:deal][:days] || Deal::Days.keys.join(',')
    params[:deal][:termsandconditions] = params[:deal][:termsandconditions].present? && params[:deal][:termsandconditions].is_a?(Array) ? params[:deal][:termsandconditions].join("\r\n") : params[:deal][:termsandconditions]
    params[:deal][:features] = params[:deal][:features].present? && params[:deal][:features].is_a?(Array) ? params[:deal][:features].join("\r\n") : params[:deal][:features]
    params[:deal][:outlet_ids] ||= []
    params[:deal][:notification_text] = params[:deal][:notification_text] || params[:deal][:main_line]
    params[:deal][:publish] = params[:deal][:publish] || "1"
    if params[:deal][:same_as_store].present? && params[:deal][:same_as_store] == "true"
      start_time = @store.start_time
      end_time = @store.end_time
      params[:deal]["notification_time_from(4i)"] = start_time.strftime('%H')
      params[:deal]["notification_time_from(5i)"] = start_time.strftime('%S')
      params[:deal]["notification_time_to(4i)"] = end_time.strftime('%H')
      params[:deal]["notification_time_to(5i)"] = end_time.strftime('%S')
    end
    params.require(:deal).permit(:main_line, :description, :notification_text,:publish,
      :notification_radius, :gender, :is_age_limit, :age_from, :age_to, 
      :publish, :publish_date, :duration, :notification_time_from, 
      :notification_time_to, :days, :is_coupon, :coupon_text, :deal_category_id,
      :main_image, :featured_image, :coupon_image, :delete_coupon_image,:termsandconditions,:features,
      :price,:discounted_price, :deal_type, :last_coupons, :last_start_time, :last_end_time,:days,:root_deal_category_id,
      :sub_deal_category_ids, :max_quantity, :internet_handling_charges,
      outlet_ids: [])
  end

  def update_deal_categories
    return [] unless (root_deal_category = DealCategory.root_categories.find_by_id(params[:deal][:root_deal_category_id])).present?
    root_deal_category.deal_catgories(*params[:deal][:sub_deal_category_ids])  
  end

  def deal_live_with_approval?(deal)
    deal.is_last_minute_deal? && current_user.is_lmd_live_without_approval?
  end

  def deal_resource
    @deal = @deals.find(params[:id])
  end

  def send_lmd_notifications
    requested_notification_to_follower = RequestedNotification.create(deal_id: @deal.id, 
      merchant_user: current_user,
      message: @deal.main_line, target_to: :followers, target_device: :all)
    requested_notification_to_in_distance = RequestedNotification.create(deal_id: @deal.id,
      merchant_user: current_user,
      message: @deal.main_line, target_to: :all, target_device: :all, 
      target_distance: 2.5)
    requested_notification_to_follower.approve!(nil)
    requested_notification_to_follower.deliver!(nil)
    requested_notification_to_in_distance.approve!(nil)
    requested_notification_to_in_distance.deliver!(nil)
  end
end
