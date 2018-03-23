class QuotaController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :store
  before_filter :get_manageable

  # GET /quota/1/edit
  def edit
  end

  # PATCH/PUT /quota/1
  def update
    respond_to do |format|
      if @quotum.update(quotum_params)
        format.html { redirect_to store_dashboard_path(@store), notice: 'Quotum was successfully updated.' }
        format.json { render :show, status: :ok, location: @quotum }
      else
        format.html { render :edit }
        format.json { render json: @quotum.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def quotum_params
      params.require(:quotum).permit(:total, :used, 
        :premium_notification_total, :premium_notification_used)
    end

    def get_manageable
      @manageable = @store.manageable  
    end
end
