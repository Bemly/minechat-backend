Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"

  # 为用户资源生成所有标准 RESTful API 路由 (index, show, create, update, destroy)
  resources :users

  # 为房间资源生成所有标准 RESTful API 路由
  resources :rooms do
    # 嵌套路由：一个房间可以包含多个消息
    resources :messages, only: [:index, :create] # 获取房间内消息，创建新消息
    # 嵌套路由：一个房间可以管理多个成员
    #   对于 Member 控制器，通常不会单独为其定义完整的 resources 路由，
    #   因为 Member 是连接 User 和 Room 的中间表。它的操作通常是嵌套在 Room 或 User 下进行的。
    resources :members, only: [:index, :create, :destroy] # 获取成员列表，添加/移除成员
  end

  # 对于消息资源，只暴露 show, update, destroy (因为 index 和 create 在 rooms 下)
  resources :messages, only: [:show, :update, :destroy]

  # Member 资源通常不单独暴露，因为它总是关联到 Room 和 User
  # 如果需要，可以单独定义，但常见做法是嵌套在 Room 下管理
  # resources :members, only: [:show, :update] # 例如，查看或更新成员的 joined_at 或 unread_id

  # 之后你可以添加认证、其他功能相关的路由
end
