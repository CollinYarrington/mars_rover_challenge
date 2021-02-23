Rails.application.routes.draw do
  root to: 'plateau#index'

  get 'index/grid', to: 'plateau#index'
  get '/create/rover' , to: 'plateau#create'
  get '/start', to: 'plateau#start'
  get '/rovers/instructions' , to: 'plateau#set_up_rover'
  # resources :plateau

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
