Rails.application.routes.draw do
  # deviseのルーティングをusersに変更
  devise_for :users, controllers: {
    registrations: 'users/registrations'
  }
  #住所情報登録ページ表示の"new_address"と登録"create_address"アクションのルーティング
  devise_scope :user do
    get 'addresses', to: 'users/registrations#new_address'
    post 'addresses', to: 'users/registrations#create_address'
  end
  root to: "home#index"
end


## devise_for と devise_scopeについて
# http://www.code-magagine.com/?p=13096を参照
# どちらもdeviseのルーティングをカスタマイズしたい場合に使用

# devise_for
    # devise_for(
    #   :users, -> deviseのログインユーザーの対象モデル
    #   path: 'users', -> deviseで生成するURLの基準パス
    #   module: 'devise' -> deviseのコントローラの場所 / 「controllers/devise/session_controller.rb」と「controllers/devise/registration_controller.rb」
    # )
# devise_scope
  # deviseに新たにルーティング追加したい場合に使用
    # devise_scope :users do
    #   get 'ルーティング情報', to: 'users/registrations#アクション'
    # end