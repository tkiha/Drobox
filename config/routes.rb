Rails.application.routes.draw do
  devise_for :users,
     controllers: { sessions: 'user/sessions' }

  devise_scope :user do
    authenticated :user do
      # 認証済みユーザーの場合はファイル一覧へ
      root to: 'folders#show'
    end
    unauthenticated :user do
      root to: 'devise/registrations#new', as: :unauthenticated_root
    end
  end

  # idを省略可能とした。省略時はroot扱いとなる
  # get 'items(/:id)' => 'folders#show', as: 'items', defaults: {id: nil} # folders の show でOK
  get 'search(/:id)' => 'folders#search', as: 'search_folder', defaults:  {id: nil} # => folders の member に移動

  # folder_idはどのフォルダ一覧へ戻るかを示すためのキー。省略可能。省略時はrootへ戻る事になる
  get 'find(/:folder_id)' => 'find#new', as: 'find', defaults: {folder_id: nil}
  post 'find(/:folder_id)' => 'find#show', as: 'find_result', defaults: {folder_id: nil}

  resources :folders, only: [:show] do
    member do
      # /folders/3/search | /search/3
      get :search
    end
    resources :upfiles, only: [:edit, :create, :new, :destroy, :update, :show] do
      member do
        get :download
        post :move, :copy
        # resources :fileshares 下3行をまとめたい
        get :newshares, to: 'fileshares#new'
        patch :updateshares, to: 'fileshares#update'
        delete :destroyshares, to: 'fileshares#destroy'
        namespace 'toshare' do
          get :show, to: 'upfiles#show'
          get :download, to: 'upfiles#download'
        end
      end
    end

    resources :folders, controller: :subfolders, only: [:edit, :create, :new, :destroy, :update, :show] do
      member do
        post :move, :copy
        # resources :shares にしたい
        get :newshares, to: 'foldershares#new'
        patch :updateshares, to: 'foldershares#update'
        delete :destroyshares, to: 'foldershares#destroy'
        namespace 'toshare' do
          get :show, to: 'subfolders#show'
        end
      end
    end
  end

  namespace 'fromshare' do
    resources :items, only: [:index]
  end

  namespace 'toshare' do
    resource :items, only: [:show] # resources :items, only: [:index] 上と同じにしたい
    resources :folder_items, only: [:show] # folders にしたい
  end

  resources :events, only: [:index]
end
