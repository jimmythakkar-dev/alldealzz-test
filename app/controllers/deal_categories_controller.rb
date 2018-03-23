class DealCategoriesController < ApplicationController
  load_and_authorize_resource
  before_action :load_resource

  # GET /deal_categories
  def index
    
  end

  # GET /deal_categories/1
  def show
  end

  # GET /deal_categories/new
  def new
  end

  # GET /deal_categories/1/edit
  def edit
  end

  # POST /deal_categories
  def create
    @deal_category = DealCategory.new(deal_category_params)
    respond_to do |format|
      if @deal_category.save
        @category_version = CategoryVersion.first.increment(:version)
        @category_version.save
        format.html { redirect_to deal_categories_url, notice: 'Deal category was successfully created.' }
        format.json { render :show, status: :created, location: @deal_category }
      else
        format.html { render :new }
        format.json { render json: @deal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /deal_categories/1
  def update
    respond_to do |format|
      if @deal_category.update(deal_category_params)
        @category_version = CategoryVersion.first.increment(:version)
        @category_version.save
        format.html { redirect_to deal_categories_url, notice: 'Deal category was successfully updated.' }
        format.json { render :show, status: :ok, location: @deal_category }
      else
        format.html { render :edit }
        format.json { render json: @deal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /deal_categories/1
  def destroy
    @deal_category.destroy
    respond_to do |format|
      format.html { redirect_to deal_categories_url, notice: 'Deal category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def deal_category_params
      params.require(:deal_category).permit(:name, :deal_type, :priority_order, :logo_image, :category_version)
    end

    def load_resource
      @deal_categories = DealCategory.root_categories
      @deal_category = @deal_categories.find(params[:id]) if params[:id].present?
    end  

end
