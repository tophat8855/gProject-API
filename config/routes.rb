Rails.application.routes.draw do
  resources :stations
  resources :walk
  resources :bike
  resources :legs

  get '/bart' => 'stations#bart'
end
