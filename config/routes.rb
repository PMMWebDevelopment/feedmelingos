Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  resources :preloadsources
  resources :sourcetypes
  resources :languages do
    member do
      post 'feeds'
    end
  end
  root :to => 'home#index'


  
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
