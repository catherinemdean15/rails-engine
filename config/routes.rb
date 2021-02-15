Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :merchants, only: %i[index show] do
        get '/items', to: 'merchants#items'
      end
      resources :items do
        get '/merchant', to: 'items#merchant'
      end
    end
  end
end
