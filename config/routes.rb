Rails.application.routes.draw do
  
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html
devise_for :users
  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check
  namespace :api do
    namespace :v1 do
      resources :ballots
      post "login", to: "sessions#new"
      delete "logout",to: "sessions#destroy"
      devise_scope :user do
        post 'signup',to: "registrations#create"  
      end
    end
  end

  # Defines the root path route ("/")
  
end
