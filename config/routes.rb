Rails.application.routes.draw do
  devise_for :users,
     controllers: { sessions: 'user/sessions' }

  devise_scope :user do
    authenticated :user do
      # 認証済みユーザーの場合はファイル一覧へ
      root :to => 'folders#index'
    end
    unauthenticated :user do
      root :to => 'devise/registrations#new', as: :unauthenticated_root
    end
  end

  match 'fromsharelist' => 'shares#fromshares', :as => 'list_from_share', :via => :get
  match 'tosharelist' => 'shares#toshares', :as => 'list_to_share', :via => :get

  match 'tosharefolder/:id' => 'toshare_folders#index', :as => 'toshare_list_folder', :via => :get

  # idを省略可能とした。省略時はroot扱いとなる
  match 'list(/:id)' => 'folders#index', :as => 'list_folder', :defaults => {id: nil}, :via => :get
  match 'search(/:id)' => 'folders#search', :as => 'search_folder', :defaults => {id: nil}, :via => :get

  # folder_idはどのフォルダ一覧へ戻るかを示すためのキー。省略可能。省略時はrootへ戻る事になる
  match 'find(/:folder_id)' => 'find#new', :as => 'find', :defaults => {folder_id: nil}, :via => :get
  match 'findresult(/:folder_id)' => 'find#show', :as => 'find_result', :defaults => {folder_id: nil}, :via => :post

  # URLにフォルダIDが欲しいので folders でくくっている。actionは不要なのでdummyとした
  resources :folders, only: [:dummy] do
    resources :upfiles do
      member do
        get :download
        post :move, :copy
        get :newshares, to: 'fileshares#new'
        patch :updateshares, to: 'fileshares#update'
        delete :destroyshares, to: 'fileshares#destroy'
      end
    end

    resources :folders, controller: :subfolders, only: [:edit, :create, :new, :destroy, :update, :show] do
      member do
        post :move, :copy
        get :newshares, to: 'foldershares#new'
        patch :updateshares, to: 'foldershares#update'
        delete :destroyshares, to: 'foldershares#destroy'
      end
    end
  end
end
