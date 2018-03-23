class PremiumNotificationsController < ApplicationController
  load_and_authorize_resource :store
  load_and_authorize_resource through: :store
  before_filter :get_manageable

  # GET /premium_notifications
  def index
    @premium_notifications = @store.premium_notifications
  end

  # GET /premium_notifications/1
  def show
  end

  # GET /premium_notifications/new
  def new
  end

  # GET /premium_notifications/1/edit
  def edit
  end

  # POST /premium_notifications
  def create
    @premium_notification = @store.premium_notifications.new(premium_notification_params)

    respond_to do |format|
      if @premium_notification.save
        format.html { redirect_to [@store, @premium_notification], notice: 'Premium notification was successfully created.' }
        format.json { render :show, status: :created, location: @premium_notification }
      else
        format.html { render :new }
        format.json { render json: @premium_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /premium_notifications/1
  def update
    respond_to do |format|
      if @premium_notification.update(premium_notification_params)
        format.html { redirect_to [@store, @premium_notification], notice: 'Premium notification was successfully updated.' }
        format.json { render :show, status: :ok, location: @premium_notification }
      else
        format.html { render :edit }
        format.json { render json: @premium_notification.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /premium_notifications/1
  def destroy
    @premium_notification.destroy
    respond_to do |format|
      format.html { redirect_to store_premium_notifications_url(@store), notice: 'Premium notification was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_status
    @premium_notifications = @store.premium_notifications
    @premium_notification = @premium_notifications.find(params[:premium_notification_id])
    @sucess = @premium_notification.toggle_status if @premium_notification
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def premium_notification_params
      params[:premium_notification][:days] = params[:premium_notification][:days].present? && params[:premium_notification][:days].is_a?(Array) ? params[:premium_notification][:days].join(',') : params[:premium_notification][:days]
      params.require(:premium_notification).permit(:notification_text, 
        :radius, :latitude, :longitude, :publish, :publish_date, :duration, 
        :notification_time_from, :notification_time_to, :days, :deal_category_id,
        geo_coordinate_attributes: [:latitude, :longitude, :id])
    end

    def get_manageable
      @manageable = @store.manageable  
    end
end
