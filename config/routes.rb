Rails.application.routes.draw do
  devise_for :users

  get 'events/index'
  root 'events#index'
  post 'events/create_event_a', to: 'events#create_event_a'
  post 'events/create_event_b', to: 'events#create_event_b'
end
