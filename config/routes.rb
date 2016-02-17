Rails.application.routes.draw do

  get 'check_duplicate/:item_ids/:brand/:order_id', to:'order_items#check_duplicate'

  resources :order_items

  resources :orders do
    get :submit_to_ordered, as: :submit_to_ordered
    get :show_all, as: :show_all, on: :collection
    get :show_selected, as: :show_selected, on: :collection
  end

  root to: 'visitors#index'

  get 'make_admin' => 'users#make_admin'

  devise_for :users

  resources :users
  resources :items do
    get :autocomplete_item_name, on: :collection
    post :import, on: :collection
    get :template, on: :collection
    get :download, on: :collection
  end
end
