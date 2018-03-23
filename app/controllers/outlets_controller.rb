class OutletsController < ApplicationController
	load_and_authorize_resource :store
  load_and_authorize_resource through: :store
  before_filter :get_manageable

  def index
    @outlets = @store.outlets
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    respond_to do |format|
      if @outlet.save
        format.html { redirect_to [@store, @outlet], notice: 'Outlet was successfully created.' }
        format.json { render :show, status: :created, location: @outlet }
      else
        format.html { render :new }
        format.json { render json: @outlet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @outlet.update(outlet_params)
        format.html { redirect_to [@store, @outlet], notice: 'Outlet was successfully updated.' }
        format.json { render :show, status: :ok, location: @outlet }
      else
        format.html { render :edit }
        format.json { render json: @outlet.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @outlet.destroy
    respond_to do |format|
      format.html { redirect_to store_outlets_url(@store), notice: 'Outlet was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def change_status
    index
    @outlet = @outlets.find(params[:outlet_id])
    @sucess = @outlet.toggle_status if @outlet
  end

  # def change_coupon
  #   deals = @store.deals
  #   deal = deals.find(params[:deal_id]) if params[:deal_id].present?
  #   @deal_coupon = params[:deal_coupon]
  #
  #   if deal.present?
	 #    @coupon_text = [deal.coupon_text.present?].all? ? deal.coupon_text : nil
	 #    @coupon_image = [deal.coupon_image.present?, deal.coupon_image.url.present?].all? ?  deal.coupon_image.url : nil
  #   end
  # end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def outlet_params
      # params[:deal][:days] = params[:deal][:days].present? && params[:deal][:days].is_a?(Array) ? params[:deal][:days].join(',') : params[:deal][:days]
      params.require(:outlet).permit(:address, :contact_phone, :contact_person,
        :status, :location, :latitude, :longitude, :radius,:locality, :phone_number,
        geo_coordinate_attributes: [:latitude, :longitude, :id])
    end

    def get_manageable
      @manageable = @store.manageable  
    end
end
