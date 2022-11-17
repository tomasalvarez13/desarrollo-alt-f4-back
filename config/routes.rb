# frozen_string_literal: true

Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#login'
  post 'register', to: 'users#register'
  get 'me', to: 'application#me'
  get 'post/filter/price', to: 'posts#filter_price'
  get 'post/filter/placement', to: 'posts#filter_placement'
  get 'post/filter/user/:id', to: 'posts#filter_artist'
  get 'post/filter', to: 'posts#filter_all'
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
  resources :users
  resources :posts
  resources :appointments

  post '/presigned_url', to: 'direct_upload#create'

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
