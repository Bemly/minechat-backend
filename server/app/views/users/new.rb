class Users::New < ApplicationView
  def initialize(user: nil, errors: [])
    @user = user
    @errors = errors
  end

  def content
    h1 { "新建用户" }

    if @errors.any?
      div(class: "flash-alert") do
        ul do
          @errors.each { |e| li { e } }
        end
      end
    end

    div(class: "mc-card") do
      form(action: "/users", method: "post", class: "mc-form") do
        div(class: "form-group") do
          label(for: "username") { "用户名" }
          input(type: "text", id: "username", name: "user[username]", value: @user&.username)
        end
        div(class: "form-group") do
          label(for: "nickname") { "昵称" }
          input(type: "text", id: "nickname", name: "user[nickname]", value: @user&.nickname)
        end
        div(class: "form-group") do
          label(for: "email") { "邮箱" }
          input(type: "email", id: "email", name: "user[email]", value: @user&.email)
        end
        div(class: "form-group") do
          label(for: "passwd") { "密码" }
          input(type: "password", id: "passwd", name: "user[passwd]")
        end
        div(class: "actions") do
          button(type: "submit", class: "mc-btn mc-btn-accent") { "创建" }
          a(href: "/users", class: "mc-btn") { "返回" }
        end
      end
    end
  end
end
