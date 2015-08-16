Rails.application.routes.draw do
  root to: 'visitors#index'
  devise_for :users
  resources :users
  get 'make_admin' => 'users#make_admin'
end
