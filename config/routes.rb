Rails.application.routes.draw do
  root "static_pages#home"
  get    "/about",     to: "static_pages#about"
  get    "/contact",   to: "static_pages#contact"
  get    "/signup",    to: "users#new"
  get    "/login",     to: "sessions#new"
  post   "/login",     to: "sessions#create"
  delete "/logout",    to: "sessions#destroy"
  resources :users do
    member do
      get :following, :followers
    end
  end
  resources :account_activations, only: [:edit]
  resources :password_resets,      only: [:new, :create, :edit, :update]
  # get    "/newpost",   to: "beansposts#new"
  resources :beansposts
  # ,          only: [:index, :new, :show, :edit, :update :create, :destroy]
  resources :relationships,       only: [:create, :destroy]
  resources :bookmarks,           only: [:create, :destroy]
end
