class SalesUserStoresController < ApplicationController
  load_and_authorize_resource
  load_and_authorize_resource :sales_user

  def create_live
    store = Store.new(name: @sales_user_store.name,
      logo: @sales_user_store.logo, 
      address: @sales_user_store.address,
      phone: @sales_user_store.phone_number,
      contact_persone: @sales_user_store.mgr_name,
      city_id: @sales_user_store.city_id,
      status: true)
    @sucess = false
    if @sales_user_store.status?
      Store.transaction do
        user = User.new(email: @sales_user_store.email, 
          password: 'password', password_confirmation: 'password')
        store.user = user
        if @sucess = store.save
          geo_coordinates = GeoCoordinate.new(latitude: @sales_user_store.latitude,
                                              longitude: @sales_user_store.longitude,
                                              locationable_id: store.id,
                                              locationable_type: "Store")
          geo_coordinates.save
          @sales_user_store.update_attributes(creatable: store, status: false)
        end
      end
    end  
    
    if @sucess
      begin
        StoreMailer.welcome_email2(store, store.user).deliver_later
      rescue Exception => e
        @sucess = false
        @errors = 'Notification mail wasn\'t sent successfully.'  
      end
    else
      @errors = store.errors.full_messages.to_sentence  if store.errors.present?
    end
  end

  def update
    if @sales_user_store.update(sales_user_store_params)
      redirect_to @sales_user, notice: 'Sales store was successfully updated.'
    else
      render :edit
    end
  end

  private
  def sales_user_store_params
    params.require(:sales_user_store).permit(:name, :latitude, 
      :longitude, :address_line_one, :address_line_two, :phone_number,
      :email, :start_time, :end_time, :working_days, :status, :logo, :cover_pic, 
      :mgr_name, :mgr_contact_number, :owner_name, :owner_contact_number)
  end
end
