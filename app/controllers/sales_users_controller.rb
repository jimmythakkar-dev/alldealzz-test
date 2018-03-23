class SalesUsersController < ApplicationController
  load_and_authorize_resource

  def index
    @sales_users = SalesUser.order('created_at desc')
  end

  def create
    if @sales_user.save(sales_user_params)
      redirect_to @sales_user, notice: 'Sales user was successfully created.'
    else
      render :new
    end
  end

  def update
    if @sales_user.update(sales_user_params)
      redirect_to @sales_user, notice: 'Sales user was successfully updated.'
    else
      render :edit
    end
  end

  def change_status
    @sucess = @sales_user.toggle_status
  end

  private
  def sales_user_params
    params.require(:sales_user).permit(:identifier, :password, :name, :contact_phone, :status)
  end
end
