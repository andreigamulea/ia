Rails.application.routes.draw do
  
  devise_for :users, controllers: {
    sessions: 'devise/sessions',
    registrations: 'devise/registrations',
    passwords: 'devise/passwords',
    confirmations: 'devise/confirmations',
    unlocks: 'devise/unlocks'
  }
  
  #devise_for :users, controllers: {
   # sessions: 'users/sessions'
  #}
  get 'home/index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  root "home#index"
end
