# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'revenue', to: 'revenues#date_range'
      get 'revenue/merchants/:id', to: 'revenues#merchant_revenue'
      get 'revenue/items', to: 'revenues#items_by_revenue'
      get 'revenue/unshipped', to: 'revenues#unshipped_orders'
      get 'revenue/weekly', to: 'revenues#weekly'
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
