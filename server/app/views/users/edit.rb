class Users::Edit < ApplicationView
  def initialize(user:, errors: [])
    @user = user
    @errors = errors
  end

  def content
    div(class: "form-container") do
      h1 { "编辑用户" }

      if @errors.any?
        div(class: "flash-alert ore-card") do
          div(class: "alert-icon") { "⚠" }
          ul(class: "alert-list") do
            @errors.each { |e| li { e } }
          end
        end
      end

      div(class: "ore-card form-card") do
        div(class: "form-header") do
          div(class: "form-icon") { "✏️" }
          div(class: "form-title") { "编辑用户信息" }
          div(class: "form-subtitle") { @user.nickname || @user.username }
        end

        form(action: "/users/#{@user.id}", method: "post", class: "mc-form") do
          input(type: "hidden", name: "_method", value: "patch")

          div(class: "form-group") do
            label(for: "username") { "用户名" }
            input(type: "text", id: "username", name: "user[username]", value: @user.username, placeholder: "用户名")
          end

          div(class: "form-group") do
            label(for: "nickname") { "昵称" }
            input(type: "text", id: "nickname", name: "user[nickname]", value: @user.nickname, placeholder: "显示名称")
          end

          div(class: "form-group") do
            label(for: "email") { "邮箱" }
            input(type: "email", id: "email", name: "user[email]", value: @user.email, placeholder: "user@example.com")
          end

          div(class: "actions") do
            button(type: "submit", class: "mc-btn mc-btn-accent") { "更新用户" }
            a(href: "/users/#{@user.id}", class: "mc-btn") { "取消" }
          end
        end
      end
    end

    style { safe(USERS_EDIT_CSS) }
  end

  USERS_EDIT_CSS = <<~CSS
    .form-container {
      max-width: 500px;
      margin: 0 auto;
    }

    .form-card {
      padding: 28px 32px;
    }

    .form-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 3px solid var(--mc-border);
    }

    .form-icon {
      font-size: 2rem;
    }

    .form-title {
      font-size: 1.3rem;
      font-weight: 700;
      color: #1a1a1a;
      text-shadow: 1px 1px 0 rgba(0,0,0,0.1);
    }

    .form-subtitle {
      margin-left: auto;
      font-size: 0.9rem;
      color: var(--mc-muted);
      padding: 4px 10px;
      border: 2px solid var(--mc-border);
      background: rgba(240, 240, 240, 0.6);
    }

    .alert-list {
      margin: 0;
      padding-left: 20px;
    }

    .alert-list li {
      color: #ef4444;
      margin-bottom: 4px;
    }

    @media (max-width: 640px) {
      .form-card {
        padding: 20px;
      }

      .form-header {
        flex-direction: column;
        text-align: center;
      }

      .form-subtitle {
        margin-left: 0;
        margin-top: 8px;
      }
    }
  CSS
end
