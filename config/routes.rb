Rails.application.routes.draw do
  devise_for :users,
    controllers: {sessions: 'user/sessions', }
  #todo :authenticate_user!フィルタに#引っかかった場合のルーティング
  #skip: [:sessions]

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

  match 'list(/:id)' => 'folders#index', :as => 'list_folder', :defaults => {id: nil}, :via => :get
  resources :folders, only: [:index] do
    resources :upfiles do
      member do
        get :download
      end
    end
    resources :folders, only: [:edit, :create, :new, :destroy, :update]
  end
end
