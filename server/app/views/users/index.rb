class Users::Index < ApplicationView
  def initialize(users: [])
    @users = users
  end

  def content
    h1 { "用户列表" }

    div(class: "actions", style: "justify-content: center; margin-bottom: 24px; margin-top: 0;") do
      a(href: "/users/new", class: "mc-btn mc-btn-accent") { "+ 新建用户" }
      a(href: "/", class: "mc-btn") { "← 返回" }
    end

    if @users.any?
      div(class: "card-grid") do
        @users.each do |user|
          a(href: "/users/#{user.id}") do
            div(class: "user-card ore-card") do
              div(class: "user-avatar") do
                span { "👤" }
              end
              div(class: "user-info") do
                div(class: "user-name") { user.nickname || user.username || "未知" }
                div(class: "user-username") { "@#{user.username}" }
                if user.email.present?
                  div(class: "user-email") { user.email }
                end
              end
              div(class: "user-status") do
                span(class: user.online_status ? "status-online" : "status-offline") do
                  user.online_status ? "● 在线" : "○ 离线"
                end
              end
            end
          end
        end
      end
    else
      div(class: "empty-state") do
        div(class: "empty-icon") { "👥" }
        p { "暂无用户" }
        p(style: "margin-top: 8px;") { "点击上方按钮创建第一个用户" }
      end
    end

    style { safe(USERS_INDEX_CSS) }
  end

  USERS_INDEX_CSS = <<~CSS
    .user-card {
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: 20px 16px;
      gap: 12px;
      cursor: pointer;
      text-decoration: none;
    }

    .user-card:hover {
      background: #3a3b3e;
    }

    .user-avatar {
      width: 60px;
      height: 60px;
      background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
      border: 2px solid var(--mc-border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2rem;
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.4);
    }

    .user-info {
      text-align: center;
      flex: 1;
    }

    .user-name {
      font-size: 1.1rem;
      font-weight: 700;
      color: var(--mc-text);
      margin-bottom: 4px;
      min-height: 2rem;
    }

    .user-username {
      font-size: 0.9rem;
      color: var(--mc-muted);
      margin-bottom: 4px;
      min-height: 1.2rem;
    }

    .user-email {
      font-size: 0.8rem;
      color: #888;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      max-width: 100%;
    }

    .user-status {
      padding: 4px 12px;
      border: 2px solid var(--mc-border);
      background: #3a3b3e;
      border-radius: 0;
    }

    .status-online {
      color: #22c55e;
      font-weight: 700;
      font-size: 0.85rem;
    }

    .status-offline {
      color: #888;
      font-weight: 700;
      font-size: 0.85rem;
    }

    .empty-state {
      text-align: center;
      padding: 48px 20px;
      background: var(--mc-bg-default);
      border: 2px solid var(--mc-border);
      box-shadow: inset -2px -2px 0px rgba(255,255,255,0.15), inset 2px 2px 0px rgba(0,0,0,0.3);
    }

    .empty-icon {
      font-size: 3rem;
      margin-bottom: 16px;
    }

    .empty-state p {
      color: #d1d1d1;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
      margin: 0;
    }

    @media (max-width: 640px) {
      .card-grid {
        grid-template-columns: repeat(auto-fill, minmax(140px, 1fr));
      }

      .user-avatar {
        width: 48px;
        height: 48px;
        font-size: 1.5rem;
      }

      .user-name {
        font-size: 1rem;
      }
    }
  CSS
end
