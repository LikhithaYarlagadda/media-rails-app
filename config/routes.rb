Rails.application.routes.draw do
  post '/login', to: 'auth#login'
  post '/user/role_change', to: 'users#change_role'
  
  resources :users, only: %i[create]

  resources :articles do
    post 'approve', on: :member
    post 'reject', on: :member
    resources :comments, only: %i[index create update destroy] do
      resources :reactions, only: %i[index create update destroy]
    end
    resources :reactions, only: %i[index show create update destroy]
  end

  resources :sections, only: %i[index show create update destroy]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
end
