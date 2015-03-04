Rails.application.routes.draw do
  resources :stations
  resources :walk

  get '/bart' => 'stations#bart'
end
