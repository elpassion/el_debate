Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  namespace :api do
    resource :comment, only: [:create]
    resource :login, only: [:create]
    resource :debate, only: [:show]
    resource :vote, only: [:create]
  end

  namespace :slack do
    post :comments, to: 'comments#help', constraints: CommentHelpConstraint
    resources :comments, only: [:create]
  end

  root to: redirect('admin/debates#index')

  get '/dashboard/:slug', to: 'dashboard#index'
end