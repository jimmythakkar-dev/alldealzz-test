class StoreCategoriesController < ApplicationController
  authorize_resource
  before_action :set_store_category, only: [:show, :edit, :update, :destroy]

  # GET /store_categories
  def index
    @store_categories = StoreCategory.all
  end

  # GET /store_categories/1
  def show
  end

  # GET /store_categories/new
  def new
    @store_category = StoreCategory.new
  end

  # GET /store_categories/1/edit
  def edit
  end

  # POST /store_categories
  def create
    @store_category = StoreCategory.new(store_category_params)

    respond_to do |format|
      if @store_category.save
        format.html { redirect_to store_categories_url, notice: 'Store category was successfully created.' }
        format.json { render :show, status: :created, location: @store_category }
      else
        format.html { render :new }
        format.json { render json: @store_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /store_categories/1
  def update
    respond_to do |format|
      if @store_category.update(store_category_params)
        format.html { redirect_to store_categories_url, notice: 'Store category was successfully updated.' }
        format.json { render :show, status: :ok, location: @store_category }
      else
        format.html { render :edit }
        format.json { render json: @store_category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /store_categories/1
  def destroy
    @store_category.destroy
    respond_to do |format|
      format.html { redirect_to store_categories_url, notice: 'Store category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_store_category
      @store_category = StoreCategory.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def store_category_params
      params.require(:store_category).permit(:name, :description)
    end
end
