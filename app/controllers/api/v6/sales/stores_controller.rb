class Api::V6::Sales::StoresController < Api::V6::Sales::BaseController
  before_action :sales_user_store_authorize!
  
  def index
    render_success(template: :index)
  end

  def show
    render_success(template: :show)
  end

  def create
    @store = current_user.sales_user_stores.new(
        name: params[:name],
        logo: params[:logo],
        cover_pic: params[:cover_pic],
        latitude: params[:latitude],
        longitude: params[:longitude],
        address_line_one: params[:address_line_one],
        address_line_two: params[:address_line_two],
        phone_number: params[:phone_number],
        email: params[:email],
        start_time: params[:start_time],
        end_time: params[:end_time],
        working_days: params[:working_days],
        mgr_name: params[:mgr_name],
        mgr_contact_number: params[:mgr_contact_number],
        owner_name: params[:owner_name],
        owner_contact_number: params[:owner_contact_number]
      )
    if @store.save
      render_success(template: :create)
    else  
      render_error(422, @store.errors.full_messages.to_sentence)
    end  
  end
end
