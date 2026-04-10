class Users::Show < ApplicationView
  def initialize(user: {})
    @user = user
  end

  def view_template
    div(class: "container") do
      h1 { @user.dig("attributes", "nickname") || @user.dig("attributes", "username") || "用户详情" }

      div(class: "card") do
        dl do
          dt { "用户名" }
          dd { @user.dig("attributes", "username") }
          dt { "昵称" }
          dd { @user.dig("attributes", "nickname") }
          dt { "邮箱" }
          dd { @user.dig("attributes", "email") }
          dt { "在线状态" }
          dd { @user.dig("attributes", "online_status") ? "在线" : "离线" }
        end
      end

      div(class: "actions") do
        a(href: "/users", class: "btn") { "返回" }
        a(href: "/users/#{@user["id"]}/edit", class: "btn") { "编辑" }
      end
    end
  end
end
