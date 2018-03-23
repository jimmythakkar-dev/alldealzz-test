namespace :v1 do
  # Draw sales API
  api_routes_draw(:sales_v1)

  # Draw merchant API
  api_routes_draw(:merchant_v1)
    
    
  resources :registrations, only: [:create]
  post 'registrations/update', to: "registrations#update"
  post 'registrations/check_referral_code', to: "registrations#check_referral_code"
  resources :password_resets, only: [:create]

  resources :end_users, only: [:index]
  post 'user/status', to: "end_users#status"
  post 'user/notification_status', to: "end_users#notification_status"
  post 'user/add_feedback', to: "end_users#add_feedback"
  # Categories
  post 'set_categories', to: "end_users#set_categories"
  post 'get_categories', to: "end_users#get_categories"
  post 'categories', to: "end_users#categories"

  post 'deals', to: "deals#index"
  post 'deals/:id', to: "deals#show"
  post 'deals/:id/reviews', to: "deals#reviews"
  post 'deals/:id/add_review', to: "deals#add_review"
  post 'deals/:id/add_favourite', to: "deals#add_favourite"
  post 'favourite_deals', to: "deals#favourites"
  post 'deals/:id/use', to: "deals#use"
  post 'booked_deals', to: "deals#booked_deals"
  post 'categorised_deals', to: "deals#categorised_deals"
  post 'interactive_map_stores', to: "stores#interactive_map_stores"

  # Stores
  resources :stores, only: [] do
    post :index, on: :collection
    post :show, on: :member
    post :add_favourite, on: :member
    post :follow, on: :member
  end
  post 'favourite_stores', to: "stores#favourites"
  post 'followed_stores', to: "stores#follows"
  
  # Locals
  namespace :local do
    post :app_update, controller: :base
    post :ios_update, controller: :base
    post :notify_store, controller: :base
    post :stores, controller: :stores, action: :index
  end

  namespace :unauth do
    post 'faq'
    post 'about_us'
  end  
  
  # Malls
  resources :malls, only: [] do
    post :index, on: :collection
    post :show, on: :member
    post :follow, on: :member
  end  
  post 'followed_malls', to: "malls#follows"
  
  resources :searches, only: [] do
    post :text, on: :collection
  end  
end