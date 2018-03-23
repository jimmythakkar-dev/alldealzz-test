class SubDealCategoriesController < ApplicationController
  load_and_authorize_resource :deal_category
  load_and_authorize_resource class: DealCategory, through: :deal_category


  def index
  end

  def show
  end

  def new
  end

  def edit
  end

  def create
    @sub_deal_category = @deal_category.sub_deal_categories.new(sub_deal_category_params)
    respond_to do |format|
      if @sub_deal_category.save
        format.html { redirect_to deal_category_sub_deal_categories_path(@deal_category), notice: 'Sub deal category was successfully created.' }
        format.json { render :show, status: :created, location: @sub_deal_category }
      else
        format.html { render :new }
        format.json { render json: @sub_deal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @sub_deal_category.update(sub_deal_category_params)
        format.html { redirect_to deal_category_sub_deal_categories_path(@deal_category), notice: 'Sub deal category was successfully updated.' }
        format.json { render :show, status: :ok, location: @sub_deal_category }
      else
        format.html { render :edit }
        format.json { render json: @sub_deal_category.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @sub_deal_category.destroy
    respond_to do |format|
      format.html { redirect_to deal_category_sub_deal_categories_path(@deal_category), notice: 'Sub deal category was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def sub_deal_category_params
      params.require(:deal_category).permit(:name)
    end
end
