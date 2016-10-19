Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  resources :debates, only: [:index, :show, :new, :create]

  namespace :api do
    resource :login, only: [:create]
    resource :debate, only: [:show]
    resource :vote, only: [:create]
  end

  root 'debates#index'

  get '/dashboard/:id', to: 'dashboard#index'
end
