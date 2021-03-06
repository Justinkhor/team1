Rails.application.routes.draw do

  resources :passwords, controller: "clearance/passwords", only: [:create, :new]
  resource :session, controller: "clearance/sessions", only: [:create]
  resources :images, only: [:destroy]

  resources :users, controller: "users" do
    resource :password,
      controller: "clearance/passwords",
      only: [:create, :edit, :update]
  end

  get "/sign_in" => "clearance/sessions#new", as: "sign_in"
  delete "/sign_out" => "sessions#destroy", as: "sign_out"
  get "/sign_up" => "users#new", as: "sign_up"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "sneakers#index"
  get "/sneakers" => "sneakers#index"
  get "/watches" => "watches#index"
  get "/handbags" => "handbags#index"
  get "/auth/:provider/callback" => "sessions#create_from_omniauth"

  post "/get_stock" => "items#getstock", as: "get_stock"
  get "/about" => "about#index"


  resources :items do
    resources :stocks do
      resources :bids, only: [:create, :new]
    end
  end

  resources :stocks, only: [:index]

  resources :bids, only: [:destroy, :index] do
    resources :braintree, only: [:new, :create]
  end

  get "/my_items" => "items#myitem"
  get '/search', to: 'items#search', as: 'search'

end
