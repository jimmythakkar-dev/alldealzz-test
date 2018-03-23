class ApiDetailsController < ApplicationController
	load_and_authorize_resource
	before_filter :get_resource, only: [ :edit, :show, :update]
	def index
		api_details = ApiDetail.all
		@api_details = api_details.order('created_at desc').page(params[:page]).per(10)
	end
	
	def new
		
	end
	
	def edit
		
	end
	
	def create
		@api_detail = ApiDetail.new(api_detail_params)
		respond_to do |format|
			if @api_detail.save
				format.html { redirect_to  @api_detail, notice: 'ApiDetail was successfully created.' }
				format.json { render :show, status: :created, location: @api_detail }
			else
				format.html { render :new }
				format.json { render json: @api_detail.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def show
		
	end
	
	def update
		respond_to do |format|
			if @api_detail.update(api_detail_params)
				format.html { redirect_to  @api_detail, notice: 'ApiDetail was successfully updated.' }
				format.json { render :show, status: :ok, location: @api_detail }
			else
				format.html { render :edit }
				format.json { render json: @api_detail.errors, status: :unprocessable_entity }
			end
		end
	end

	private
	
	def api_detail_params
		params.require(:api_detail).permit(:app_version, :app_type, :message, :api_version, :device_type, :faq, :about_us)
	end

	def get_resource
		@api_detail = ApiDetail.find(params[:id])
	end
end

