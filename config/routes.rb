Rails.application.routes.draw do
  devise_for :users
  resources :rooms
  resources :messages
  root to: 'rooms#index'
  get "/load_more", to: "rooms#load_more"
  get "/load_more_unread", to: "rooms#load_more_unread_message"
  get "/request_to_room", to: "rooms#request_to_room"
  post "/access_user_to_room", to: "rooms#access_user_to_room"
  post "/kick_out_of_room", to: "rooms#kick_out_of_room"

  mount ActionCable.server => '/cable'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
