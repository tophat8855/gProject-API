Rails.application.routes.draw do
  resources :stations
  resources :walk
  resources :bike

  get '/bart' => 'stations#bart'
end
