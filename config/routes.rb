  Rails.application.routes.draw do
    devise_for :admin_users, ActiveAdmin::Devise.config
    ActiveAdmin.routes(self)
    root :to => 'home#index'
    devise_for :users do
      get '/users/sign_out' => 'devise/sessions#destroy'
    end
    resources :preloadsources
    resources :sourcetypes
    resources :languages
    resources :users
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
