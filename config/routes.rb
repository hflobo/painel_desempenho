Rails.application.routes.draw do
  devise_for :users
  root to: 'dashboards#show'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :indicators do
 # get 'indicators_index', to: 'indicators#index'
 # get 'new_indicator', to: 'indicator#new'
    resources :kpi
  end

  resources :alerts

  get 'alerts_sent', to: 'alerts#alerts_sent'
  get 'alerts_received', to: 'alerts#alerts_received'
  get 'alerts_filed', to: 'alerts#alerts_filed'

  resources :dashboards, only: %i[show new create destroy] do
    resources :kpis, only: %i[show new create destroy]
  end
end
