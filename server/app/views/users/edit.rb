class Users::Edit < ApplicationView
  def initialize(user:, errors: [])
    @user = user
    @errors = errors
  end

  def content
    h1 { "编辑用户" }

    if @errors.any?
      div(class: "flash-alert") do
        ul do
          @errors.each { |e| li { e } }
        end
      end
    end

    div(class: "mc-card") do
      form(action: "/users/#{@user.id}", method: "post", class: "mc-form") do
        input(type: "hidden", name: "_method", value: "patch")
        div(class: "form-group") do
          label(for: "username") { "用户名" }
          input(type: "text", id: "username", name: "user[username]", value: @user.username)
        end
        div(class: "form-group") do
          label(for: "nickname") { "昵称" }
          input(type: "text", id: "nickname", name: "user[nickname]", value: @user.nickname)
        end
        div(class: "form-group") do
          label(for: "email") { "邮箱" }
          input(type: "email", id: "email", name: "user[email]", value: @user.email)
        end
        div(class: "actions") do
          button(type: "submit", class: "mc-btn mc-btn-accent") { "更新" }
          a(href: "/users", class: "mc-btn") { "返回" }
        end
      end
    end
  end
end
