Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post "signup", to: "users#create"
      post "login", to: "auth#login"
      get "/teams/available", to: "teams#available"

      resources :teams do
        post "join", on: :member
        get "members", on: :member

        resources :channels do
          post "join", on: :member
          resources :messages
        end
        resources :memberships
      end

      resources :users
      resources :direct_messages
      get "direct_messages/conversation/:user_id", to: "direct_messages#conversation"
    end
  end

  # ✅ Move this line *inside* the routes block:
  match '*path', via: :options, to: ->(env) {
    [
      204,
      {
        'Content-Type' => 'text/plain',
        'Access-Control-Allow-Origin' => env['HTTP_ORIGIN'] || '*',
        'Access-Control-Allow-Methods' => 'GET, POST, PUT, PATCH, DELETE, OPTIONS, HEAD',
        'Access-Control-Allow-Headers' => 'Origin, Content-Type, Accept, Authorization, Token',
        'Access-Control-Max-Age' => '1728000'
      },
      []
    ]
  }

  get "up" => "rails/health#show", as: :rails_health_check
end
