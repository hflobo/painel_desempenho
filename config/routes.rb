Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :indicators
 # get 'indicators_index', to: 'indicators#index'
 # get 'new_indicator', to: 'indicator#new'

  resources :alerts

  get 'alerts_sent', to: 'alerts#alerts_sent'
  get 'alerts_received', to: 'alerts#alerts_received'
  get 'alerts_filed', to: 'alerts#alerts_filed'
end
