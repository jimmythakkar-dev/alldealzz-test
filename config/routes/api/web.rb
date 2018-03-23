namespace :web do
  resources :password_resets, only: [] do
    get '/:id', action: :edit, on: :collection, as: :edit
    patch '/:id', action: :update, on: :collection, as: :update
  end
end