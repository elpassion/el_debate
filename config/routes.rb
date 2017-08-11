Rails.application.routes.draw do
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  concern :api_base do
    resources :comments, only: [:index, :create]
    resource :login, only: [:create]
    resource :debate, only: [:show]
    resource :vote, only: [:create]
  end

  namespace :api do
    scope module: :edge, constraints: EdgeApiConstraint do
      concerns :api_base
    end
    concerns :api_base
  end

  namespace :slack do
    post :comments, to: 'comments#help', constraints: CommentHelpConstraint
    resources :comments, only: [:create]
  end

  root to: redirect('/admin/debates')

  get '/dashboard/:slug', to: 'dashboard#index'
end