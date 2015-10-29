Rails.application.routes.draw do

  get 'check_duplicate/:item_id', to:'order_items#check_duplicate'

  resources :order_items

  resources :orders

  root to: 'visitors#index'

  get 'make_admin' => 'users#make_admin'

  devise_for :users

  resources :users
  resources :items do
    get :autocomplete_item_name, on: :collection
    post :import, on: :collection
    get :template, on: :collection
  end
end
