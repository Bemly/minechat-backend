Rails.application.routes.draw do
  # 错误页
  get "404", to: "errors#not_found"
  get "422", to: "errors#unprocessable_entity"
  get "500", to: "errors#internal_server_error"

  # 健康检查
  get "up" => "rails/health#show", as: :rails_health_check

  # 根路径
  root "home#index"

  # 前端页面
  resources :users
  resources :rooms do
    resources :messages, only: [:index, :create]
    resources :members, only: [:index, :create, :destroy]
  end
  resources :messages, only: [:show, :update, :destroy]

  # API (Marshal 序列化，供 TUI/GUI/Android 客户端使用)
  namespace :api do
    resources :users
    resources :rooms do
      resources :messages, only: [:index, :create]
      resources :members, only: [:index, :create, :destroy]
    end
    resources :messages, only: [:show, :update, :destroy]
  end

  # 其他所有路径导向 404
  match "*path", to: "errors#not_found", via: :all
end
