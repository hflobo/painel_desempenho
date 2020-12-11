Rails.application.routes.draw do
  get 'alerts/index'
  get 'alerts/show'
  get 'alerts/new'
  get 'alerts/create'
  get 'alerts/edit'
  get 'alerts/update'
  get 'alerts/destroy'
  devise_for :users
  root to: 'pages#home'
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
