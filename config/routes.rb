Rails.application.routes.draw do

  resources :cars

  resources :transfer_items

  resources :transfers do
    post :import_transfer_items
    member do
      get :transfer_items
      match :submit, via: [:patch,:post]
      match :receive, via: [:patch,:post]
    end
  end

  resources :sale_items
  get 'sale_items/store/:store_id/item/:item_id', to: 'sale_items#by_store_and_item', as: :by_store_and_item

  resources :sales do
    get :sale_items
    match :submit_to_ordered, as: :submit_to_ordered, via: [:patch,:post]
    match :submit_to_sold, as: :submit_to_sold, via: [:patch,:post]
    match :mark_as_sold, as: :mark_as_sold, via: [:patch,:post]
    match :submit_to_credited, as: :submit_to_credited, via: [:patch,:post]
    match :submit_to_sampled, as: :submit_to_sampled, via: [:patch,:post]
    get :return, on: :collection
    get :pop_up_fs_num_edit
    member do
      get :print
    end
  end

  resources :return_items

  resources :customers do
    get :cars
    get :autocomplete_customer_name, on: :collection
    get :pop_up_show
    get :pop_up_edit
  end

  resources :stores do
    get :sales
    get :for_sales, on: :collection
  end

  get 'check_duplicate/:item_ids/:brand/:order_id', to:'order_items#check_duplicate'

  get 'pop_up_add_item_to_order/:item_id', to:'orders#pop_up_add_item', as:'pop_up_add_item_to_order'

  resources :order_items

  resources :orders do
    get :submit_to_ordered, as: :submit_to_ordered
    get :show_all, as: :show_all, on: :collection
    get :show_selected, as: :show_selected
    member do
      get :download
    end
  end

  resources :proformas do
    get :proforma_items
    match :submit_to_submitted, as: :submit_to_submitted, via: [:patch,:post]
    match :mark_as_sold, as: :mark_as_sold, via: [:patch,:post]
    member do
      get :print
    end
  end

  resources :proforma_items

  root to: 'dashboard#index'

  get 'make_admin' => 'users#make_admin'

  devise_for :users, :controllers => { :sessions => "custom_sessions" }

  resources :users do
    member do
      get :activity_log
      get :activity_log_data
    end
  end
  resources :items do
    get :autocomplete_item_name, on: :collection
    get :autocomplete_item_sale_price, on: :collection
    get :autocomplete_item_sale_order, on: :collection
    post :import, on: :collection
    post :import_non_original, on: :collection
    post :bulk_update, on: :collection
    get :template, on: :collection
    get :non_original_template, on: :collection
    get :bulk_update_template, on: :collection
    get :download, on: :collection
    get :download_inventory, on: :collection
    get :import_export, as: :import_export, on: :collection
    post :ip_xp, as: :ip_xp, on: :collection
    get :pop_up_show
    get :pop_up_edit
    member do
      get :copy
    end
  end

  resource :dashboard, only: [:index], controller: :dashboard do
    get :sales_chart_data
  end
  get 'configs' => 'configs#index'

  resource :searches do
    get :all, on: :collection, as: :all
    get :items, on: :collection, as: :items
    get :customers, on: :collection, as: :customers
    get :item_lookup, on: :collection, as: :item_lookup
    get :orders, on: :collection, as: :orders
    get :vin, on: :collection, as: :vin
    get :sales, on: :collection, as: :sales
    get :proformas, on: :collection, as: :proformas
    get :transfers, on: :collection, as: :transfers
  end
end
