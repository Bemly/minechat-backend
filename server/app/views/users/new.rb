class Users::New < ApplicationView
  def initialize(user: nil, errors: [])
    @user = user
    @errors = errors
  end

  def content
    div(class: "form-container") do
      h1 { "新建用户" }

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
          div(class: "form-icon") { "👤" }
          div(class: "form-title") { "创建新用户" }
        end

        form(action: "/users", method: "post", class: "mc-form") do
          div(class: "form-group") do
            label(for: "username") do
              span { "用户名" }
              span(class: "form-required") { "*" }
            end
            input(type: "text", id: "username", name: "user[username]", value: @user&.username, required: true, placeholder: "输入用户名")
          end

          div(class: "form-group") do
            label(for: "nickname") { "昵称" }
            input(type: "text", id: "nickname", name: "user[nickname]", value: @user&.nickname, placeholder: "输入显示名称")
          end

          div(class: "form-group") do
            label(for: "email") { "邮箱" }
            input(type: "email", id: "email", name: "user[email]", value: @user&.email, placeholder: "user@example.com")
          end

          div(class: "form-group") do
            label(for: "passwd") do
              span { "密码" }
              span(class: "form-required") { "*" }
            end
            input(type: "password", id: "passwd", name: "user[passwd]", required: true, placeholder: "设置密码")
          end

          div(class: "actions") do
            button(type: "submit", class: "mc-btn mc-btn-accent") { "创建用户" }
            a(href: "/users", class: "mc-btn") { "取消" }
          end
        end
      end
    end

    style { safe(USERS_NEW_CSS) }
  end

  USERS_NEW_CSS = <<~CSS
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
      border-bottom: 2px solid rgba(255, 255, 255, 0.15);
    }

    .form-icon {
      font-size: 2rem;
    }

    .form-title {
      font-size: 1.3rem;
      font-weight: 700;
      color: var(--mc-text);
    }

    .form-required {
      color: #ef4444;
      margin-left: 4px;
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
    }
  CSS
end
