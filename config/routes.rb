Rails.application.routes.draw do
  root to: 'units#index'

  resources :units, only: %i[index create] do
    get :download
  end
end
