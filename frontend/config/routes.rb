Rails.application.routes.draw do
  # 健康检查
  get "up" => "rails/health#show", as: :rails_health_check

  # 根路径
  root "home#index"

  # 用户
  resources :users

  # 房间
  resources :rooms do
    resources :messages, only: [:index, :create]
    resources :members, only: [:index, :create, :destroy]
  end

  # 消息
  resources :messages, only: [:show, :update, :destroy]
end
