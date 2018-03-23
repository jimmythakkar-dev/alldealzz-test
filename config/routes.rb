class ActionDispatch::Routing::Mapper
  def api_routes_draw(version)
    instance_eval(File.read(Rails.root.join("config/routes/api/#{version}.rb")))
  end
end

Rails.application.routes.draw do
  
  devise_for :users
  resources :users, only: [] do
    get :change_password, on: :collection
    get :change_password, on: :member
    put :update_password, on: :member
    get :change_username, on: :collection
    get :change_username, on: :member
    put :update_username, on: :member
  end  
  
  root "dashboard#index"
  resources :dashboard, only: [] do
    post :stop_pending_delayed_jop, on: :collection
  end


  namespace :app_helpers do
    get :api_json_lookup
    post :notify_reset
    get '/', action: :index
    post :active_google_app
    post :active_apple_app
    get 'api_details', action: :api_details_show
    post 'api_details/:id', action: :api_details_update, as: :api_details_update
  end
  
  resources :api_details

  resources :cashbacks do
    post :change_status
    post :deal, on: :collection
    post :category, on: :collection
  end
  resources :malls do
    get 'dashboard', to: "malls#dashboard"
    get :credentials, on: :member
    post :change_status
    resources :stores
  end

  resources :notifications, only: [:index] do
  end  
  
  resources :end_users  do
    get :points, on: :member
    post :add_points, on: :member
    post :block_user, on: :member
  end 
  resources :store_categories, expect: [:show]
  resources :deal_categories, expect: [:show] do
    resources :sub_deal_categories, expect: [:show]
  end  
  resources :stores do
    get 'dashboard', to: "stores#dashboard"
    get 'analytics', to: "stores#analytics"
    get :credentials, on: :member
    get 'analytics_chart', to: "stores#analytics_chart"
    post :change_status
    post :update_expiry_date

    resources :premium_notifications do
      post :change_status
    end
    resources :deals do
      post :sub_categories, on: :member
      get :categories, on: :member
      post :add_categories, on: :member
      post :change_status
      post :change_approver
      post 'remove_image/:deal_detail_images_id', action: :remove_image, as: :remove_image
    end
    resources :quota, only: [:edit, :update]
    resources :outlets do 
      post :change_status
    end
    resources :feeds do
      post :change_status
    end
  end

  resources :newsletters do 
    post :deals, on: :member
    get :categories, on: :member
    post :add_deals, on: :member
    post :category, on: :member
  end

  resources :deals, only: [:index]

  resources :requested_notifications do
    post :merchantable_form, on: :collection
    post :dealable_form, on: :collection

    post :approve, on: :member
    post :reject, on: :member
    post :deliver, on: :member
  end

  resources :transaction_details, except: [:new, :create] do
    post :settlement, on: :member
    post :unsettlement, on: :member
  end  

  resources :sales_users do
    post :change_status, on: :member
    resources :sales_user_stores, only: [:edit, :update] do
      post :create_live, on: :member
      resources :sales_user_store_photos, only: [:index] do
      end 
    end
  end

  resources :merchant_users do
    post :change_status, on: :member
    get :redeem, on: :member
    resources :requested_notifications
  end
  
  # TODO : Create under payment scope
  # scope :payment do
    namespace :payu do
      resources :callbacks, only: [] do
        post :deal_payment, on: :collection
      end  
    end

    namespace :paytm do
      resources :callbacks, only: [] do
        post :generate_checksum, on: :collection
        post :verify_checksum, on: :collection
      end
    end
  # end

  scope :api do
    # use_doorkeeper do
    #   controllers :tokens => 'api/doorkeeper/tokens'
    # end
    use_doorkeeper :scope => 'oauth/end_users' do
      controllers :tokens => 'api/doorkeeper/end_user_tokens'
      # as tokens: 'end_user_token'
      skip_controllers :applications, :authorized_applications, :authorizations, :token_info
    end

    use_doorkeeper :scope => 'oauth/sales_users' do
      controllers :tokens => 'api/doorkeeper/sales_user_tokens'
      # as tokens: 'sales_user_token'
      skip_controllers :applications, :authorized_applications, :authorizations, :token_info
    end

    use_doorkeeper :scope => 'oauth/merchant_users' do
      controllers :tokens => 'api/doorkeeper/merchant_user_tokens'
      # as tokens: 'merchant_user_token'
      skip_controllers :applications, :authorized_applications, :authorizations, :token_info
    end
  end

  namespace :api do
    api_routes_draw(:web)
    api_routes_draw(:v1)
    api_routes_draw(:v2)
    api_routes_draw(:v3)
    api_routes_draw(:v4)
    api_routes_draw(:v5)
    api_routes_draw(:v6)
    match "*path", :to => "v1/base#routing_error_api", :via => :all
  end
end
