Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # Serve websocket cable requests in-process
  # mount ActionCable.server => '/cable'

  resources :debates, only: [:index, :new, :create]

  namespace :api do
    resource :login, only: [:create]
    resource :debate, only: [:show]
    resource :vote, only: [:create]
  end

  root 'debates#index'
end
