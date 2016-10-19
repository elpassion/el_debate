Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resource :login, only: [:create]
    resource :debate, only: [:show]
    resource :vote, only: [:create]
  end

  root to: redirect('admin/debates#index')

  get '/dashboard/:id', to: 'dashboard#index'
end
