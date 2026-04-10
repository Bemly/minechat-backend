class Users::Edit < ApplicationView
  def initialize(user: {}, errors: [])
    @user = user
    @errors = errors
  end

  def view_template
    div(class: "container") do
      h1 { "编辑用户" }

      if @errors.any?
        ul(class: "flash-alert") do
          @errors.each { |e| li { e } }
        end
      end

      div(class: "card") do
        form(action: "/users/#{@user["id"]}", method: "post") do
          input(type: "hidden", name: "_method", value: "patch")
          div(class: "form-group") do
            label(for: "username") { "用户名" }
            input(type: "text", id: "username", name: "user[username]", value: @user.dig("attributes", "username"))
          end
          div(class: "form-group") do
            label(for: "nickname") { "昵称" }
            input(type: "text", id: "nickname", name: "user[nickname]", value: @user.dig("attributes", "nickname"))
          end
          div(class: "form-group") do
            label(for: "email") { "邮箱" }
            input(type: "email", id: "email", name: "user[email]", value: @user.dig("attributes", "email"))
          end
          button(type: "submit", class: "btn") { "更新" }
        end
      end

      div(class: "actions") do
        a(href: "/users", class: "btn") { "返回" }
      end
    end
  end
end
