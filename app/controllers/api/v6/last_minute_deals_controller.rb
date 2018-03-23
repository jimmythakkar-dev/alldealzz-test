class Api::V6::LastMinuteDealsController < Api::V6::BaseController
	before_action :end_user_authorize!

	def index
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f

    @deals = deals_result(lat, lng).page(params[:page]).per(10)
    @deals.each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }
	  render_success(template: :index)
	end

  def expired_deals
    lat = params[:latitude].to_f
    lng = params[:longitude].to_f
    category_ids = params[:category_id]
    city_filter = current_user_city
    _deals =  Deal.click_notify_allowed_deals(city_filter, Deal::DealType[:lmd]).in_last_deal_time
    if category_ids.present?
      _deals = _deals.interested_deals(category_ids)
    end
 
    @deals = _deals.with_locations.nearest(lat,lng).page(params[:page]).per(10)
    @deals.each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }
    render_success(template: :index)
  end

  def add_reminder
    @deal = Deal.find(params[:id])
    reminder_time = Time.zone.parse(params[:datetime])
    reminder =  @deal.end_user_deal_reminders.new(end_user: current_user, reminder_time: reminder_time)
    if reminder.save!
      render_success(reminder_id: reminder.id)
    else
      render_error(422, reminder.errors.full_messages.to_sentence)
    end
  end

  def remove_reminder
    @deal = Deal.find(params[:id])
    reminder =  @deal.end_user_deal_reminders.find_by(id: params[:reminder_id])
    if reminder.present? && reminder.update_attributes(status: false)
      render_success
    else
      render_error(422, 'No reminder updated')
    end
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
    _deals = Deal.click_notify_allowed_deals(city_filter, Deal::DealType[:lmd]).in_last_minute_deal_time.at_days
    if category_ids.present?
      _deals = _deals.interested_deals(category_ids)
    end

    case type
    when 1
      _deals.popular_deals
    when 2
      _deals.best_seller_deals
    when 3
      _deals.view_count_deals
    when 4
      # sorted_deals = _deals.nearest_deals(lat,lng,3).each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }.sort_floating(:steps)
      # Kaminari.paginate_array(sorted_deals).page(params[:page]).per(10)
      _deals.with_locations.nearest(lat,lng)
    else
      _deals.order('deals.publish_date')
    end
  end
end
