class Api::V5::FeedsController < Api::V5::BaseController
  before_action :end_user_authorize!
  before_action :get_feed_resource, only: [:toggle_favourite, :comments, :add_comment, :add_reminder, :remove_reminder, :show]
  #   :edit_review, :add_favourite, :use, :booking_code, :booking_code_with_otp]

  # def index
  #   lat = params[:latitude].to_f
  #   lng = params[:longitude].to_f
  #
  #   # TODO : Inappropriate
  #   doorkeeper_token.update_location(lat, lng) rescue false
  #
  #   @deals = deals_result(lat, lng).page(params[:page]).per(10)
  #   @deals.each { |d| d.steps = d.store.sorted_outlet_steps(d, lat, lng) }
  #   render_success(template: :index)
  # end
  #
  # def upcoming_deals
  #   params[:deals_type] = "upcoming"
  #   index
  # end
  #
  # def categorised_upcoming_deals
  #   index
  # end
  #
  # # TODO : only for enabled / allowed deals ?
   def show
     @days = @feed.days.present? ? @feed.days.split(",") : []
     render_success(template: :show)
  end

  # TODO : only for enabled / allowed deals ?
  def comments
    @feed_reviews = @feed.end_user_feed_reviews.includes(:end_user).order('end_user_feed_reviews.created_at desc')
    render_success(template: :comments)
  end
  #
  def add_comment
    comment = @feed.end_user_feed_reviews.new(end_user: current_user, message: params[:comment])
    render_success if comment.save!
  end
  #
  # def edit_review
  #   end_user_reviewed_deal = @deal.reviews.where(end_user_id: current_user.id).last
  #   end_user_reviewed_deal.message = params[:review_text]
  #   end_user_reviewed_deal.rating = params[:rating].to_i
  #   render_success if end_user_reviewed_deal.save!
  # end

  def toggle_favourite
    favourite = @feed.end_user_feed_favourites.where(end_user: current_user)
    if favourite.blank?
      favourite = @feed.end_user_feed_favourites.new(end_user: current_user)
      render_success if favourite.save!
    else
      render_success if favourite.destroy_all
    end
  end

  def favourites
    @feeds = current_user.favourite_feeds.order("feed_type DESC").page(params[:page]).per(10)
    render_success(template: :favourites)
  end

  def add_reminder
    reminder_time = Time.zone.parse(params[:datetime])
    reminder =  @feed.end_user_feed_reminders.new(end_user: current_user, reminder_time: reminder_time)
    if reminder.save!
      render_success(reminder_id: reminder.id)
    else
      render_error(422, reminder.errors.full_messages.to_sentence)
    end
  end

  def remove_reminder
    reminder =  @feed.end_user_feed_reminders.find_by(id: params[:reminder_id])
    if reminder.present? && reminder.update_attributes(status: false)
      render_success
    else
      render_error(422, 'No reminder updated')
    end
  end

  private


  def get_feed_resource
    @feed = Feed.find(params[:id])
    @store = @feed.store
  end
end
