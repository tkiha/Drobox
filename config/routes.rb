Rails.application.routes.draw do
  devise_for :users, controllers: {sessions: 'user/sessions'}
  root :to => 'users#index'
  resources :users do
    collection do
      post 'test'
    end  
  end

end
