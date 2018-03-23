class CashbacksController < ApplicationController
	load_and_authorize_resource
	before_filter :get_resource, only: [ :edit, :show, :update]
	def index
		cashbacks = Cashback.all
		if params[:search].present?
			search_text = params[:search][:text]
			conditions = ['lower(cashbacks.code) like ? or lower(cashbacks.text) like ?', "%#{search_text.downcase}%", "%#{search_text.downcase}%" ]
		end
		@cashbacks = cashbacks.where(conditions).order('created_at desc').page(params[:page]).per(10)
	end
	
	def new
		
	end
	
	def edit
		
	end
	
	def create
		@cashback = Cashback.new(cashback_params)
		respond_to do |format|
			if @cashback.save
				format.html { redirect_to  @cashback, notice: 'cashback was successfully created.' }
				format.json { render :show, status: :created, location: @cashback }
			else
				format.html { render :new }
				format.json { render json: @cashback.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def show
		@deal = Deal.find_by_id(params[:deal_id])	
	end
	
	def update
		respond_to do |format|
			if @cashback.update(cashback_params)
				format.html { redirect_to  @cashback, notice: 'Cashback was successfully updated.' }
				format.json { render :show, status: :ok, location: @cashback }
			else
				format.html { render :edit }
				format.json { render json: @cashback.errors, status: :unprocessable_entity }
			end
		end
	end
	
	def change_status
		index
		@cashback = @cashbacks.find(params[:cashback_id])
		@sucess = @cashback.toggle_status if @cashback 
	end
	def deal
		store_id = params[:store_id]
		@deals = Deal.where(store_id: store_id).click_notify_allowed_deals
		 render json: @deals 
	end
	def category
		deal_type = params[:deal_type]
		@categories = DealCategory.where(deal_type: deal_type).root_categories
		 render json: @categories
	end
	private
	
	def cashback_params
		params[:cashback]["publish_date(4i)"] = "00"
		params[:cashback]["publish_date(5i)"] = "00"
		params[:cashback]["expiry_date(4i)"] = "23"
		params[:cashback]["expiry_date(5i)"] = "59"
		params.require(:cashback).permit( :cashback_type, :status, :text, :discount, :code, :deal_id, :deal_category_id, :image, :store_id, :max_time_useable, :points, :duration, :publish_date, :expiry_date, :total_coupons, :termsandconditions, :is_trending, :trending_order)
	end
	
	def get_resource
		@cashback = Cashback.find(params[:id])
	end
end
