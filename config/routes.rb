Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  root 'camps#index'
  
  devise_for :users,
    controllers: { 
      omniauth_callbacks: 'users/omniauth_callbacks',
      registrations: 'users/registrations' 
  }

  get 'tags/:tag', to: 'camps#index', as: :tag

  resources :camps, :path => 'dreams' do
    resources :images
    resources :people, only: [:show, :update]
    post 'join', on: :member
    post 'archive', on: :member
    patch 'toggle_granting', on: :member
    patch 'update_grants', on: :member
    patch 'tag', on: :member
  end

  get '/pages/:page' => 'pages#show'
  get '/me' => 'users#me'
  get '/howcanihelp' => 'howcanihelp#index'
  
  get '/rails/mailers' => "rails/mailers#index"
  get '/rails/mailers/*path' => "rails/mailers#preview"

  get '*unmatched_route' => 'application#not_found'
end
