Rails.application.routes.draw do
  devise_for :users, 
    controllers: {sessions: 'user/sessions', }
  #todo :authenticate_user!フィルタに引っかかった場合のルーティング
  #,skip: [:sessions]

  devise_scope :user do
    authenticated :user do
      root :to => 'folders#index'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
    #todo :authenticate_user!フィルタに#引っかかった場合のルーティング
    # get "/users/sign_in" => "devise/registrations#new", as: :new_user_session
  end

  resources :folders

end
