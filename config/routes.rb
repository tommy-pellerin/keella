Rails.application.routes.draw do

  
  root "static_pages#index"
  devise_for :users
  resources :users do
    resources :reservations
  end
  resources :workouts do
    resources :reservations
  end

  resources :reservations do    
    patch :update, on: :member 
    # méthode HTTP PATCH pour l’action update
    # on: :member signifie que cette route s’applique à une instance spécifique de Reservation , 
  end
  

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

end
