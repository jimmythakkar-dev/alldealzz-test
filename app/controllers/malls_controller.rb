class MallsController < ApplicationController
  load_and_authorize_resource
  before_filter :get_and_authorize_resource, 
    only: [:dashboard, :analytics, :analytics_chart, :change_status]

  # GET /malls
  def index
    @malls = get_malls
  end  

  # GET /malls/1
  def show
  end

  # GET /malls/new
  def new
    @mall.status = current_user.present?
  end

  # GET /malls/1/edit
  def edit
  end

  # POST /malls
  def create
    @mall = Mall.new(mall_params)
    @mall.status = false unless (user_signed_in? && current_user.super_admin?)

    respond_to do |format|
      if @mall.save
        begin
          MallMailer.welcome_email2(@mall, @mall.user).deliver_later
        rescue Exception => e
          flash[:alert] = 'Notification mail wasn\'t sent successfully.'  
        end
        format.html { 
          if current_user.present? 
            redirect_to @mall, notice: 'Mall created successfully.'
          else  
            redirect_to new_user_session_path, notice: 'Mall registered successfully.'
          end  
        }
        format.json { render :show, status: :created, location: @mall }
      else
        format.html { render :new }
        format.json { render json: @mall.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /malls/1
  def update
    respond_to do |format|
      if @mall.update(mall_params)
        format.html { redirect_to @mall, notice: 'Mall was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  # DELETE /malls/1
  def destroy
    @mall.destroy
    respond_to do |format|
      format.html { redirect_to malls_url, notice: 'Mall was successfully destroyed.' }
    end
  end

  def change_status
    @malls = get_malls
    @sucess = @mall.toggle_status  
  end

  def change_password
  end

  private
    def mall_params
      params.require(:mall).permit(:name, :phone, :city_id, :latitude, :longitude,
        :radius, :address, :contact_phone, :contact_persone, :status, 
        :location, :store_category_id, :logo, :duration,
        user_attributes: [:id, :username, :email, :password, :password_confirmation],
        geo_coordinate_attributes: [:latitude, :longitude, :id])
    end

    def get_and_authorize_resource
      @mall = Mall.find(params[:mall_id])
      authorize! :dashboard, @mall
    end

    def get_malls
      Mall.all.includes(:user)
    end  
end
