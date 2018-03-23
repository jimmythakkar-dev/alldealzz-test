namespace :sales do
  resources :stores, only: [] do
    post :index, on: :collection
    post 'create', action: :create, on: :collection
    post :cities, action: :cities, on: :collection

    post :show, on: :member
    resources :photos, only: [] do
      post :index, on: :collection
      post 'create', action: :create, on: :collection
    end  
  end
end