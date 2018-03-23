class DealsController < ApplicationController
	load_and_authorize_resource
  before_filter :load_deals_resource
  # GET /deals
  def index
    all_deals = @deals
    @sponsor_order = false
    if params[:search].present?
      if (search_text = params[:search][:text]).present?
        condtions = ['lower(deals.main_line) like ?', "%#{search_text.downcase}%"]
      end

      if (search_selected = params[:search][:selected]).present?
        all_deals = case search_selected
        when 'allowed'
          all_deals.allowed_deals
        when 'not_allowed'
          all_deals.disabled
        when 'expired_in_next_7_days'
          all_deals.expired_in(7)
        when 'sponsored'
          @sponsor_order = true
          all_deals.sponsored_deals
        when 'all'
          all_deals
        end
      end
    end

    @deals = all_deals.where(condtions)
      .order('created_at desc').page(params[:page]).per(10)
  end

  # GET /deals/1
  def show
    @deal_detail_images = @deal.deal_detail_images
  end

  # GET /deals/new
  def new
    @outlets = @store.outlets if @store.has_outlets?
  end

  # GET /deals/1/edit
  def edit
    @outlets = @store.outlets if @store.has_outlets?
  end

  # POST /deals
  def create
    @deal = @store.deals.new(deal_params)
    respond_to do |format|
      if @deal.save
        if params[:images]
          
          params[:images].each { |image|
            @deal.deal_detail_images.create(image: image)
          }
        end
        format.html { redirect_to [@store, @deal], notice: 'Deal was successfully created.' }
        format.json { render :show, status: :created, location: @deal }
      else
        format.html { render :new }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deals/1
  def update
    respond_to do |format|
      if @deal.update(deal_params)
        if params[:images]
          params[:images].each { |image|
            @deal.deal_detail_images.create(image: image)
          }
        end
        format.html { redirect_to [@store, @deal], notice: 'Deal was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal }
      else
        format.html { render :edit }
        format.json { render json: @deal.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deals/1
  def destroy
    @deal.destroy
    respond_to do |format|
      format.html { redirect_to store_deal_url(@store), notice: 'Deal was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def remove_image
    @deal = Deal.find(params[:deal_id])
    @deal_detail_image =  @deal.deal_detail_images.find_by_id(params[:deal_detail_images_id])
    @deal_detail_image.destroy
    respond_to do |format|
      format.html { redirect_to [@store, @deal], notice: 'Image was successfully updated.' }
      format.json { render :show, status: :ok, location: @deal }
    end
  end

  def change_status
    index
    @deal = @deals.find(params[:deal_id])
    @sucess = @deal.toggle_status if @deal 
  end

  def change_approver
    index
    @deal = @deals.find(params[:deal_id])
    @sucess = @deal.toggle_approver(current_user) if @deal 
  end

  def categories
    @root_category = @deal.root_deal_category
    @sub_categories = @root_category.present? ? @root_category.sub_deal_categories : []
    @sub_deal_categories = @deal.sub_deal_categories
  end

  def sub_categories
    @root_category = DealCategory.root_categories.find_by_id(params[:root_deal_category_id])
    @sub_categories = @root_category.present? ? @root_category.sub_deal_categories : []
    @sub_deal_categories = @deal.sub_deal_categories
  end

  def add_categories
    @deal.deal_categories = update_deal_categories
    @deal.skip_before_save = true
    @deal.save
    redirect_to categories_store_deal_path(@store, @deal), notice: 'Deal Category was successfully updated.'
  end

  private
  # Never trust parameters from the scary internet, only allow the white list through.
  def deal_params
    params[:deal][:days] = params[:deal][:days].present? && params[:deal][:days].is_a?(Array) ? params[:deal][:days].join(',') : params[:deal][:days]
    params[:deal][:outlet_ids] ||= []
    params[:deal]["expiry_date(4i)"] = "23"
    params[:deal]["expiry_date(5i)"] = "59"
    params.require(:deal).permit(:main_line, :notification_text,
      :notification_radius, :gender, :is_age_limit, :age_from, :age_to, 
      :publish, :publish_date, :expiry_date, :duration, :notification_time_from, 
      :notification_time_to, :days, :is_coupon, :coupon_text, :deal_category_id,
      :main_image, :featured_image, :coupon_image, :delete_coupon_image, :termsandconditions, :features,
      :price,:discounted_price, :deal_type, :last_coupons, :last_start_time, :last_end_time, :valid_for, :max_bookings,
      :max_quantity, :quantity_per_user, :commission_percent,:approx_date_flag, :internet_handling_charges, :is_sponsored,
      :sponsor_order, :display_timings, :appointment_mandatory, :restrict_points, outlet_ids: [], deal_detail_images: [])
  end

  def load_deals_resource
    if @store || params[:store_id].present?
      @store = Store.find(params[:store_id]) if params[:store_id].present?
      @deal = params[:id].present? ? @store.deals.find(params[:id]) : @store.deals.new
      authorize! :index, @deal
      @deals = @store.deals
    elsif @mall
      @deal = @mall.stores.first.try(:deals).try(:new)
      authorize! :index, @deal
      @deals = Deal.by_type(Mall).where('malls.id = ?', @mall.id)
    else
      authorize! :index, Deal
      @deals = Deal.all
    end
  end

  def get_manageable
    @manageable = @store.manageable  
  end

  def update_deal_categories
    return [] unless (root_deal_category = DealCategory.root_categories.find_by_id(params[:deal][:root_deal_category_id])).present?
    root_deal_category.deal_catgories(*params[:deal][:sub_deal_category_ids])  
  end
end
