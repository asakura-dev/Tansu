# -*- coding: utf-8 -*-
Rails.application.routes.draw do
  root 'home#show'

  # サインアップ・ログイン・会員情報の編集等
  devise_for :users, :controllers => {
    :sessions => "users/sessions",
    :registrations => "users/registrations",
    :passwords => "users/passwords",
    :omniauth_callbacks => "users/omniauth_callbacks"
  }
  # Ajax経由でユーザーアイコンを削除するためのルート
  devise_scope :user do
    delete '/users_icon', to:'users/registrations#delete_icon'
  end
  # 管理者周り
  namespace :admin do
    # メンバーの管理周り
    namespace :member do
      # 権限の管理
      resource :authority, :only => [:show, :update]
      # ユーザの参加承認を管理
      resource :request, :only => [:show, :update]
    end
  end

  # 備品の周り
  resources :products, :only => [:index,:create, :show,:update, :destroy] do
    resource :tags, :only => [:show,:create, :destroy]
  end
  
  # 備品の追加・編集は/admin/products以下のルートにする
  scope :admin do
    resources :products, :only => [:new,:edit]
    # 管理者用のテーブル形式の備品一覧ページ
    match 'products' => 'products#admin_index', :via => :get, as: 'admin_products'
    # Ajax経由で画像を削除するためのルート
    delete 'products/:id/image', to:'products#delete_image'
  end
  
  # 貸出管理の周り
  resources :lending, :only => [:create, :update]

  # 外部の商品検索APIを叩いてJSONを返すルート
  namespace :third do
    resource :product_search, :only => [:show]
    match 'image' => 'product_image#show', :via => :get, as: 'load_image'
  end

  # コメント
  resources :comments, :only => [:index,:create, :update, :destroy]

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end
