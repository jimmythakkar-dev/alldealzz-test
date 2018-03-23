class MerchantUsersController < ApplicationController
	load_and_authorize_resource

  def show
    condtions = if params[:search].present?
      ['lower(main_line) like ?', "%#{params[:search].downcase}%"]
    else
      []
    end


    @store = @merchant_user.store
    @deals = @merchant_user.deals.where(condtions)
      .order('created_at desc').page(params[:page]).per(10)
  end

	def index
    condtions = if params[:search].present?
      ['lower(stores.name) like ? or lower(outlets.locality) like ? or
        lower(users.email) like ? or lower(stores.phone) like ? or lower(merchant_users.identifier) like ?',
        "%#{params[:search].downcase}%", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%", "%#{params[:search].downcase}%"]
    else
      []
    end

		@merchant_users = MerchantUser.joins("
        LEFT JOIN stores ON (stores.id = merchant_users.merchantable_id and merchant_users.merchantable_type = 'Store')
        LEFT JOIN outlets ON (outlets.id = merchant_users.merchantable_id and merchant_users.merchantable_type = 'Outlet')
        LEFT JOIN users ON users.id = stores.user_id")
      .where(condtions)
      .group('merchant_users.id')
      .order('created_at desc').page(params[:page]).per(10)
	end

  def create
    @merchant_user.global_merchantable = merchant_user_params[:global_merchantable]
    if @merchant_user.save(merchant_user_params)
      redirect_to @merchant_user, notice: 'Merchant user was successfully created.'
    else
      render :new
    end
  end

  def update
    @merchant_user.global_merchantable = merchant_user_params[:global_merchantable]
    if @merchant_user.update(merchant_user_params)
      redirect_to @merchant_user, notice: 'Merchant user was successfully updated.'
    else
      render :edit
    end
  end

  def change_status
    @sucess = @merchant_user.toggle_status
  end

  def redeem
    condtions = if params[:search].present?
      ['lower(coupon_code) like ?', "%#{params[:search].downcase}%"]
    else
      []
    end

    @store = @merchant_user.store
    @booking_codes = @merchant_user.booking_codes.where(condtions)
      .order('created_at desc').page(params[:page]).per(10)
  end

  private
  def merchant_user_params
    params.require(:merchant_user).permit(:identifier, :password, :name, :status,
      :global_merchantable, :is_lmd_live_without_approval, :has_booking_codes)
  end
end
