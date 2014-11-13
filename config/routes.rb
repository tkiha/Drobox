Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'user/sessions',
  }
  devise_scope :user do
    authenticated :user do
      root :to => 'xxxxx#index'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end

end
