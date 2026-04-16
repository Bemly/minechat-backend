class Users::Show < ApplicationView
  def initialize(user:)
    @user = user
  end

  def content
    div(class: "show-container") do
      # 用户头部信息
      div(class: "user-header ore-card") do
        div(class: "user-avatar-large") { "👤" }
        div(class: "user-header-info") do
          h1(class: "user-display-name") { @user.nickname || @user.username }
          div(class: "user-username-large") { "@#{@user.username}" }
          div(class: "user-status-badge") do
            if @user.online_status
              span(class: "status-online") { "● 在线" }
            else
              span(class: "status-offline") { "○ 离线" }
            end
          end
        end
      end

      # 用户详情
      div(class: "ore-card details-card") do
        h2 { "用户详情" }
        dl do
          dt { "ID" }
          dd { @user.id.to_s }

          dt { "用户名" }
          dd { @user.username || "-" }

          dt { "昵称" }
          dd { @user.nickname || "-" }

          dt { "邮箱" }
          dd { @user.email || "-" }
        end
      end

      # 操作按钮
      div(class: "actions wide-actions") do
        a(href: "/users", class: "mc-btn") { "← 返回列表" }
        a(href: "/users/#{@user.id}/edit", class: "mc-btn mc-btn-accent") { "✏️ 编辑" }
      end
    end

    style { safe(USERS_SHOW_CSS) }
  end

  USERS_SHOW_CSS = <<~CSS
    .show-container {
      max-width: 600px;
      margin: 0 auto;
    }

    .user-header {
      display: flex;
      align-items: center;
      gap: 24px;
      padding: 32px;
      margin-bottom: 16px;
    }

    .user-avatar-large {
      width: 100px;
      height: 100px;
      background: linear-gradient(135deg, #4ade80 0%, #22c55e 100%);
      border: 2px solid var(--mc-border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 3.5rem;
      flex-shrink: 0;
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.4), 4px 4px 12px rgba(0,0,0,0.2);
    }

    .user-header-info {
      flex: 1;
      min-width: 0;
    }

    .user-display-name {
      text-align: left;
      font-size: clamp(1.4rem, 3vw, 1.8rem);
      margin-bottom: 8px;
      color: var(--mc-text);
      text-shadow: none;
    }

    .user-username-large {
      font-size: 1rem;
      color: var(--mc-muted);
      margin-bottom: 12px;
    }

    .user-status-badge {
      display: inline-block;
      padding: 6px 16px;
      border: 2px solid var(--mc-border);
      background: #3a3b3e;
    }

    .status-online {
      color: #22c55e;
      font-weight: 700;
      font-size: 0.9rem;
    }

    .status-offline {
      color: #888;
      font-weight: 700;
      font-size: 0.9rem;
    }

    .details-card {
      padding: 28px 32px;
    }

    .details-card dt {
      margin-top: 20px;
      font-size: 0.9rem;
      color: var(--mc-green-hover);
    }

    .details-card dt:first-child {
      margin-top: 0;
    }

    .details-card dd {
      font-size: 1.1rem;
      padding: 8px 0;
    }

    .wide-actions {
      justify-content: center;
      padding-top: 8px;
    }

    @media (max-width: 640px) {
      .user-header {
        flex-direction: column;
        text-align: center;
        padding: 24px;
      }

      .user-avatar-large {
        width: 80px;
        height: 80px;
        font-size: 2.5rem;
      }

      .user-display-name {
        text-align: center;
      }

      .details-card {
        padding: 20px;
      }
    }
  CSS
end
