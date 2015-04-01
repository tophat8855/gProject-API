Rails.application.routes.draw do
  #devise_for :users, controllers: { sessions: 'sessions' }
  devise_for :users, controllers: { sessions: 'sessions', :registrations => "registrations" }, :path => '', :path_names => {:sign_up => 'signup', :sign_in => 'users/sign_in'}
  resources :stations
  resources :walk
  resources :bike
  resources :legs
  resources :users

  get '/bart' => 'stations#bart'
  get '/bus' => 'bus#bus'

end
