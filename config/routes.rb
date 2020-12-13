Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :indicators do
    resources :alerts, only: %i[new create]
  end

  resources :alerts, only: %i[destroy edit update]

  get 'alerts_sent', to: 'alerts#alerts_sent'
  get 'alerts_received', to: 'alerts#alerts_received'
end
