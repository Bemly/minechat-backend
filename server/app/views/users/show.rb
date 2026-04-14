class Users::Show < ApplicationView
  def initialize(user:)
    @user = user
  end

  def view_template
    div(class: "container") do
      h1 { @user.nickname || @user.username || "用户详情" }

      div(class: "card") do
        dl do
          dt { "用户名" }
          dd { @user.username }
          dt { "昵称" }
          dd { @user.nickname }
          dt { "邮箱" }
          dd { @user.email }
          dt { "在线状态" }
          dd { @user.online_status ? "在线" : "离线" }
        end
      end

      div(class: "actions") do
        a(href: "/users", class: "btn") { "返回" }
        a(href: "/users/#{@user.id}/edit", class: "btn") { "编辑" }
      end
    end
  end
end
