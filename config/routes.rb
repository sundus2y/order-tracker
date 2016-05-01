Rails.application.routes.draw do

  resources :sale_items
  get 'sale_items/store/:store_id/item/:item_id', to: 'sale_items#by_store_and_item', as: :by_store_and_item

  resources :sales do
    get 'sale_items/:id', to:'sales#sale_items', as: :sale_items, on: :collection
    get :submit_to_sold, as: :submit_to_sold
    get :stores, on: :collection
    get :return, on: :collection
  end

  resources :customers do
    get :autocomplete_customer_name, on: :collection
  end

  get 'check_duplicate/:item_ids/:brand/:order_id', to:'order_items#check_duplicate'

  resources :order_items

  resources :orders do
    get :submit_to_ordered, as: :submit_to_ordered
    get :show_all, as: :show_all, on: :collection
    get :show_selected, as: :show_selected
  end

  root to: 'dashboard#index'

  get 'make_admin' => 'users#make_admin'

  devise_for :users

  resources :users
  resources :items do
    get :autocomplete_item_name, on: :collection
    get :autocomplete_item_sale_price, on: :collection
    post :import, on: :collection
    get :template, on: :collection
    get :download, on: :collection
    get :import_export, as: :import_export, on: :collection
  end

  resource :dashboard do

  end

  resource :search do
    get :all, on: :collection, as: :all
    get :items, on: :collection, as: :items
    get :orders, on: :collection, as: :orders
    post :sales, on: :collection, as: :sales
  end
end
