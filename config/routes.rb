Rails.application.routes.draw do
  get 'user_search/search'
  get 'micropost_search/index'
  resources :search_types
  resources :micropost_ranges
  get 'password_resets/new'
  get 'password_resets/edit'
  get 'sessions/new'
  root "static_pages#home"
  get "/search_micropost",   to:"micropost_search#search"
  get "/search_user",   to:"user_search#search"
  get  "/help",    to: "static_pages#help"
  get  "/about",   to: "static_pages#about"
  get  "/contact", to: "static_pages#contact"
  get  "/signup",  to: "users#new"
  get    "/login",   to: "sessions#new"
  post   "/login",   to: "sessions#create"
  delete "/logout",  to: "sessions#destroy"

  resources :users do
    member do
      get :following, :followers
      get :muting, :muters
    end
  end

  resources :users
  resources :account_activations, only: [:edit]
  resources :password_resets,     only: [:new, :create, :edit, :update]
  resources :microposts,          only: [:index, :create, :destroy, :edit]
  resources :relationships,       only: [:create, :destroy]
  resources :likes,               only: [:index, :create, :destroy]
  resources :bads,                only: [:create, :destroy]
  resources :mutes,               only: [:create, :destroy]

  get '/microposts', to: 'static_pages#home'

end