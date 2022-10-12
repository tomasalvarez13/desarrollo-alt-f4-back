# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :users, param: :_username
  # post '/auth/login', to: 'authentication#login'
  get '/signup', to: 'authentication#signup'
  get '/login', to: 'authentication#login'

  get '/current', to: 'users#get_current'
  get '/locations', to: 'locations#list'
  post '/locations', to: 'locations#create'
  get 'all_users', to: 'locations#all_users', as: 'all_users'
  delete 'delete_location', to: 'locations#destroy', as: 'delete_location'
  get 'other_location', to: 'locations#list_other', as: 'list_other_locations'

  # PINGS
  post 'new_ping', to: 'pings#create'
  get 'get_sended', to: 'pings#get_sended'
  get 'get_received', to: 'pings#get_received'
  get 'get_my_pings', to: 'pings#get_my_pings'
  put 'approve', to: 'pings#approve'
  put 'reject', to: 'pings#reject'
end
