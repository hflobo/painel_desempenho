Rails.application.routes.draw do
  devise_for :users
  root to: 'pages#home'
  # root to: 'dashboards#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :indicators do
    resources :kpi
  end
  resources :values
  resources :goals
  
  resources :alerts

  get 'alerts_sent', to: 'alerts#alerts_sent'
  get 'alerts_received', to: 'alerts#alerts_received'
  get 'alerts_filed', to: 'alerts#alerts_filed'

  resources :dashboards, only: %i[show new create destroy] do
    resources :kpis, only: %i[new create edit update]
  end

  resources :kpis, only: %i[destroy]
end
