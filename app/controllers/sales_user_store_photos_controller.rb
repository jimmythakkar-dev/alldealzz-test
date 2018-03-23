class SalesUserStorePhotosController < ApplicationController
  load_and_authorize_resource :sales_user
  load_and_authorize_resource :sales_user_store, through: :sales_user
  load_and_authorize_resource :sales_user_store_photo, through: :sales_user_store
end
