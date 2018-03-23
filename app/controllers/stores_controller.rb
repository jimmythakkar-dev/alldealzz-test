class StoresController < ApplicationController
  load_resource :mall
  load_and_authorize_resource :store, through: [:mall], shallow: true
  before_filter :authorize_parent

  before_filter :get_and_authorize_resource, 
    only: [:dashboard, :analytics, :analytics_chart, :change_status]
  before_filter :set_manageable, only: [:new, :create]
  before_filter :get_manageable

  # GET /stores
  def index
    all_stores = get_stores
    if params[:search].present?
      if (search_text = params[:search][:text]).present?
        condtions = ['lower(stores.name) like ? or 
          lower(users.email) like ? or 
          lower(stores.phone) like ?', 
        "%#{search_text.downcase}%", "%#{search_text.downcase}%", "%#{search_text.downcase}%"]
      end

      if (search_selected = params[:search][:selected]).present?
        all_stores = case search_selected
        when 'allowed'
          all_stores.allowed_stores
        when 'not_allowed'
          all_stores.disabled
        when 'expired_in_next_7_days'
          all_stores.expired_in(7)
        when 'all'
          all_stores
        end
      end
    end

    @stores = all_stores.where(condtions)
      .order('created_at desc').page(params[:page]).per(10)
  end

  # GET /stores/1
  def show
  end

  # GET /stores/new
  def new
    @store.status = current_user.present?
  end

  # GET /stores/1/edit
  def edit
  end

  # POST /stores
  def create
    @store.status = false unless (user_signed_in? && (current_user.super_admin? || current_user.mall_admin?))
    
    respond_to do |format|
      if @store.save
      	begin
          StoreMailer.welcome_email2(@store, @store.user).deliver_later
      	rescue Exception => e
          flash[:alert] = 'Notification mail wasn\'t sent successfully.'  
        end
        format.html { 
        	if current_user.present? 
        		redirect_to @store, notice: 'Store created successfully.'
        	else	
        		redirect_to new_user_session_path, notice: 'Store registered successfully.'
        	end	 
        }
        format.json { render :show, status: :created, location: @store }
      else
        format.html { render :new }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /stores/1
  def update
    respond_to do |format|
      if @store.update(store_params)
        format.html { redirect_to @store, notice: 'Store was successfully updated.' }
        format.json { render :show, status: :ok, location: @store }
      else
        format.html { render :edit }
        format.json { render json: @store.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /stores/1
  def destroy
    @store.destroy
    respond_to do |format|
      format.html { redirect_to stores_url, notice: 'Store was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_status
    @sucess = @store.toggle_status  
  end
  def update_expiry_date
    @reset = @store.reset_expriy_date
  end

  # GET /stores/1/dashboard
  def dashboard
  end

  # GET /stores/1/analytics
  def analytics
  end

  def change_password
  end

  def analytics_chart
    @store = Store.find(params[:store_id])
    filter = params[:filter]
    
    @analytics_chart_data = begin
      { 
        "Clicks" => DealAnalytic.clicks(@store).send(filter).count,
        "Notifications" => DealAnalytic.notifications(@store).send(filter).count,
        "Premium Notifications" => PremiumNotificationAnalytic.notifications(@store).send(filter).count
      }
    rescue Exception => e
      { 
        "Clicks" => DealAnalytic.clicks(@store).count,
        "Notifications" => DealAnalytic.notifications(@store).count,
        "Premium Notifications" => PremiumNotificationAnalytic.notifications(@store).count
      } 
    end 
    
    if @store.present?
      respond_to do |format|
        format.json { render json: @analytics_chart_data }
        format.js
      end
    else
      render json: {}, status: 404 
    end  
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def store_params
      params.require(:store).permit(:name, :phone, :city_id, :latitude, :longitude,
        :radius, :address, :contact_phone, :contact_persone, :status, :is_brand_store,
        :location, :store_category_id, :expiry_date, :logo, :lmd_default_image, :duration, :locality, :start_time, :end_time,
        user_attributes: [:id, :username, :email, :password, :password_confirmation],
        geo_coordinate_attributes: [:latitude, :longitude, :id])
    end

    def get_and_authorize_resource
      @store = Store.find(params[:store_id])
      authorize! :dashboard, @store
    end

    def set_manageable
      @store.manageable = if @mall.present? 
        @mall
      else
        current_user.try(:manageable)
      end   
    end

    def get_manageable
      @manageable = if @store.present?
        @store.manageable
      elsif @mall.present?
        @mall
      end  
    end  

    def get_stores
      # Store.all.includes(:user)
      if @manageable.present?
        @manageable.stores.joins(:user)
      else
        Store.accessible_by(current_ability).joins(:user)
      end  
    end 

		def authorize_parent
		  # authorize! :read, (@mall || @event)
		  authorize! :read, @mall if @mall
		end 
end
