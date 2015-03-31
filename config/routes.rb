Rails.application.routes.draw do
  resources :stations
  resources :walk
  resources :bike
  resources :legs
  resources :users

  get '/bart' => 'stations#bart'
  get '/bus' => 'bus#bus'
  get '/sign-up' => 'registrations#new', as: :signup
  post '/sign-up' => 'registrations#create'
  get '/sign-out' => 'authentication#destroy', as: :signout
end
