Rails.application.routes.draw do
  
  root "static_pages#index"
  get 'aide', to: 'static_pages#aide'
  get 'mentionslegales', to: 'static_pages#mentionslegales'
  resources :contacts, only: [:new, :create]
  devise_for :users

  resources :users do
    resources :reservations
  end
  resources :workouts do
    resources :reservations
  end
  resources :users, only: [:show] do
    resources :avatars, only: [:create]
  end
  resources :workouts, only: [:edit] do
    resources :images, only: [:create, :destroy]
  end

  resources :reservations do    
    patch :update, on: :member 
    # méthode HTTP PATCH pour l’action update
    # on: :member signifie que cette route s’applique à une instance spécifique de Reservation , 
  end
  
  scope '/checkout' do
      get 'index', to: 'checkout#index', as: 'checkouts'
      post 'create', to: 'checkout#create', as: 'checkout_create'
      get 'success', to: 'checkout#success', as: 'checkout_success'
      get 'cancel', to: 'checkout#cancel', as: 'checkout_cancel'
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
