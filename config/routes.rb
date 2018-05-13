Rails.application.routes.draw do
  root to: 'units#index'

  resources :units, only: %i[index create show] do
    get :download
  end
end
