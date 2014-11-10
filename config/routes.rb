Rails.application.routes.draw do
  devise_for :users
  root :to => 'iusers#index'
  resources :users

end
