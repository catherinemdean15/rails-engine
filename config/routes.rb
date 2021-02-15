Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        get '/items', to: 'merchants#items'
        get '/merchants_items', to: 'merchants#merchants_items'
      end
      resources :items do
        get '/merchant', to: 'items#merchant'
      end
      get '/most_items', to: 'merchants#most_items'
    end
  end
end
