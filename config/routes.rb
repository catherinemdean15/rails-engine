Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'merchants/most_items', to: 'merchants#most_items'
      get 'merchants/find_all', to: 'merchants#find_all'
      get 'merchants/find', to: 'merchants#find_one'
      resources :merchants, only: %i[index show] do
        get '/items', to: 'merchants#items'
        get '/merchants_items', to: 'merchants#merchants_items'
      end
      get 'items/find_all', to: 'items#find_all'
      get 'items/find', to: 'items#find_one'
      resources :items do
        get '/merchant', to: 'items#merchant'
      end
    end
  end
end
