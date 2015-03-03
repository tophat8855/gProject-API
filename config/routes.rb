Rails.application.routes.draw do
  resources :stations
  
  get '/bart' => 'stations#bart'
end
