class Api::V3::Sales::PhotosController < Api::V3::Sales::BaseController
  before_action :sales_user_store_authorize!

  def index
    @store_photos = @store.sales_user_store_photos.map(&:store_photo)
    render_success(template: :index)
  end

  def create
    photo = @store.sales_user_store_photos.new(photo: params[:store_photo])
    if photo.save
      render_success
    else
      render_error(422, photo.errors.full_messages.to_sentence)
    end 
  end
end