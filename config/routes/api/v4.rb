namespace :v4 do
  resources :registrations, only: [:create]
  post 'registrations/update', to: "registrations#update"
  post 'registrations/check_referral_code', to: "registrations#check_referral_code"
  post 'registrations/check_social_phone_number', to: "registrations#check_social_phone_number"
  post 'registrations/update_photo', to: "registrations#update_photo"
  resources :password_resets, only: [:create]

  resources :end_users, only: [:index]
  post 'user/status', to: "end_users#status"
  post 'user/notification_status', to: "end_users#notification_status"
  post 'user/add_feedback', to: "end_users#add_feedback"
  # Categories
  post 'set_categories', to: "end_users#set_categories"
  post 'get_categories', to: "end_users#get_categories"
  post 'categories', to: "end_users#categories"
  post 'end_user/update_city', to: "end_users#update_city"
  post 'end_user/follow_store_count', to: "end_users#follow_store_count"
  post 'end_user/notifications', to: "end_users#notifications"

  post 'deals', to: "deals#index"
  post 'deals/:id', to: "deals#show"
  post 'deals/:id/reviews', to: "deals#reviews"
  post 'deals/:id/add_review', to: "deals#add_review"
  post 'deals/:id/edit_review', to: "deals#edit_review"
  post 'deals/:id/add_favourite', to: "deals#add_favourite"
  post 'favourite_deals', to: "deals#favourites"
  post 'deals/:id/use', to: "deals#use"
  post 'booked_deals', to: "deals#booked_deals"
  post 'get_deal_sub_categories', to: "deals#get_deal_sub_categories"
  post 'deals/:id/booking_code', to: "deals#booking_code"
  post 'upcoming_deals', to: "deals#upcoming_deals"
  post 'categorised_upcoming_deals', to: "deals#upcoming_deals"
  post 'categorised_deals', to: "deals#index"
  post 'sponsored_deals', to: "deals#sponsored_deals"
  # ===============

  resources :deals, only: [] do
    resources :transaction_details, only: [] do
      post 'new', on: :collection
    end
  end

  resources :transaction_details, only: [] do
    post :index, on: :collection
  end

  resources :last_minute_deals, only: [] do
    post :index, on: :collection
    post :booking_code, on: :member, to: "deals#booking_code"
  end

  resources :exclusive_deals, only: [] do
    post :index, on: :collection
  end

  # Stores
  resources :stores, only: [] do
    post :index, on: :collection
    post :show, on: :member
    post :add_favourite, on: :member
    post :follow, on: :member
  end
  post 'favourite_stores', to: "stores#favourites"
  post 'followed_stores', to: "stores#follows"
  post 'interactive_map_stores', to: "stores#interactive_map_stores"
  post 'brand_stores', to: "stores#brand_stores"

  # Outlets
  resources :outlets, only: [] do
    post :index, on: :collection
    post :show, on: :member
  end

  # Locals
  namespace :local do
    post :app_update, controller: :base
    post :ios_update, controller: :base
    post :notify_store, controller: :base
    post :stores, controller: :stores, action: :index
    post :is_city_valid, controller: :base
    post :request_otp, controller: :base
    post :verify_otp, controller: :base
    post :update_email, controller: :base
    post :verify_phone_otp, controller: :base
    post :update_payment_status, controller: :base
    post :update_pn_id, controller: :base
    post :unreviewed_deals_listing, controller: :base
    post :configuration, controller: :base
    post :payment_options, controller: :base
  end

  namespace :unauth do
    post 'faq'
    post 'about_us'
    post 'privacy_policy'
    post 'terms_and_conditions'
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

  resources :cities, only: [] do
    post :index, on: :collection
  end

  resources :end_user_subscribed_cities, only: [] do
    post :index, on: :collection
    post :update_cities, on: :collection
  end

  resources :club_membership_details, only: [] do
    post :index, on: :collection
  end

  resources :membership_transaction_details, only: [] do
    post 'new', on: :collection
    post :update_membership_status, on: :collection
  end

  resources :voucher_code_details, only: [] do
    post :check_voucher_code, on: :collection
  end

  resources :feeds, only: [] do
    post :favourites, on: :collection
    post :favourites, on: :collection
    post :toggle_favourite, on: :member
    post :comments, on: :member
    post :add_comment, on: :member
    post :add_reminder, on: :member
    post :remove_reminder, on: :member
    post :show, on: :member
  end
end