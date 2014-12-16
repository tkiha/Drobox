Rails.application.routes.draw do
  devise_for :users,
    controllers: {sessions: 'user/sessions', }
  #todo :authenticate_user!フィルタに引っかかった場合のルーティング
  #skip: [:sessions]

  devise_scope :user do
    authenticated :user do
      root :to => 'folders#index'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
    #todo :authenticate_user!フィルタに引っかかった場合のルーティング
    # get "/users/sign_in" => "devise/registrations#new", as: :new_user_session
  end

  match 'sharelist' => 'shares#index', :as => 'list_share', :via => :get
  match 'list(/:id)' => 'folders#index', :as => 'list_folder', :defaults => {id: nil}, :via => :get
  match 'search(/:id)' => 'folders#search', :as => 'search_folder', :defaults => {id: nil}, :via => :get
  match 'find(/:folder_id)' => 'find#new', :as => 'find', :defaults => {folder_id: nil}, :via => :get
  match 'findresult(/:folder_id)' => 'find#show', :as => 'find_result', :defaults => {folder_id: nil}, :via => :post

  match 'foldershare/:folder_id/new' => 'foldershares#new', :as => 'new_foldershare', :via => :get
  match 'foldershare/:folder_id/edit' => 'foldershares#edit', :as => 'edit_foldershare', :via => :patch

  resources :folders, only: [:index] do
    resources :upfiles do
      member do
        get :download
        post :move, :copy
      end
    end
    resources :folders, controller: :subfolders, only: [:edit, :create, :new, :destroy, :update, :show] do
      member do
        post :move, :copy
      end
    end
  end
end
