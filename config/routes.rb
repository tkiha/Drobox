Rails.application.routes.draw do
   devise_for :users,
     controllers: { sessions: 'user/sessions' }

  devise_scope :user do
    authenticated :user do
      root :to => 'folders#index'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end

  match 'fromsharelist' => 'shares#fromshares', :as => 'list_from_share', :via => :get
  match 'tosharelist' => 'shares#toshares', :as => 'list_to_share', :via => :get
  match 'list(/:id)' => 'folders#index', :as => 'list_folder', :defaults => {id: nil}, :via => :get
  match 'search(/:id)' => 'folders#search', :as => 'search_folder', :defaults => {id: nil}, :via => :get
  match 'find(/:folder_id)' => 'find#new', :as => 'find', :defaults => {folder_id: nil}, :via => :get
  match 'findresult(/:folder_id)' => 'find#show', :as => 'find_result', :defaults => {folder_id: nil}, :via => :post

  match 'foldershares/:folder_id/new' => 'foldershares#new', :as => 'new_foldershares', :via => :get
  match 'foldershares/:folder_id/update' => 'foldershares#update', :as => 'update_foldershares', :via => :patch
  match 'foldershares/:folder_id/destroy' => 'foldershares#destroy', :as => 'destroy_foldershares', :via => :delete

  match 'fileshares/:upfile_id/new' => 'fileshares#new', :as => 'new_fileshares', :via => :get
  match 'fileshares/:upfile_id/update' => 'fileshares#update', :as => 'update_fileshares', :via => :patch
  match 'fileshares/:upfile_id/destroy' => 'fileshares#destroy', :as => 'destroy_fileshares', :via => :delete

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
