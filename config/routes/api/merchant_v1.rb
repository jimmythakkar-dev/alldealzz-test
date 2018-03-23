namespace :merchant do
	resources :redeems, only: [] do
	  # redeem_code
    post :deal, on: :collection
    post :code, on: :collection
  end
  post 'get_deal_sub_categories', to: "redeems#get_deal_sub_categories"

  resources :deals, only: [] do
    post :index, on: :collection
    post 'create', action: :create, on: :collection
    post :bookings, on: :collection
    post :live_deals, on: :collection
    post :past_deals, on: :collection
    post :get_deal_categories, on: :collection

    post :update, on: :member
    post :show_booking, on: :member
    post :analytics, on: :member
    post :pie_chart_analytics, on: :member
  end

  post 'store_follower_analytics', to: "deals#follower_analytics"

  resources :requested_notifications, only: [] do
    post :index, on: :collection
    post 'create', action: :create, on: :collection
  end

  resources :transaction_details, only: [] do
    post :index, on: :collection
    post :show, on: :member
  end

  # Locals
  namespace :local do
    post :app_update, controller: :base
    post :ios_update, controller: :base
    post :contact_details, controller: :base
  end
end