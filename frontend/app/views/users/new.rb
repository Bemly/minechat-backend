class Users::New < ApplicationView
  def initialize(user: {}, errors: [])
    @user = user
    @errors = errors
  end

  def view_template
    div(class: "container") do
      h1 { "新建用户" }

      if @errors.any?
        ul(class: "flash-alert") do
          @errors.each { |e| li { e } }
        end
      end

      div(class: "card") do
        form(action: "/users", method: "post") do
          div(class: "form-group") do
            label(for: "username") { "用户名" }
            input(type: "text", id: "username", name: "user[username]", value: @user[:username])
          end
          div(class: "form-group") do
            label(for: "nickname") { "昵称" }
            input(type: "text", id: "nickname", name: "user[nickname]", value: @user[:nickname])
          end
          div(class: "form-group") do
            label(for: "email") { "邮箱" }
            input(type: "email", id: "email", name: "user[email]", value: @user[:email])
          end
          div(class: "form-group") do
            label(for: "passwd") { "密码" }
            input(type: "password", id: "passwd", name: "user[passwd]")
          end
          button(type: "submit", class: "btn") { "创建" }
        end
      end

      div(class: "actions") do
        a(href: "/users", class: "btn") { "返回" }
      end
    end
  end
end
