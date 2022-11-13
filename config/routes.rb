# frozen_string_literal: true

Rails.application.routes.draw do
  post 'authenticate', to: 'authentication#login'
  # mount Rswag::Ui::Engine => '/api-docs'
  # mount Rswag::Api::Engine => '/api-docs'
  resources :users
  resources :posts
  resources :appointments

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
end
