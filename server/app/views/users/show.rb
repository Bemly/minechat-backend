class Users::Show < ApplicationView
  def initialize(user:)
    @user = user
  end

  def content
    h1 { @user.nickname || @user.username || "用户详情" }

    div(class: "mc-card") do
      dl do
        dt { "用户名" }
        dd { @user.username }
        dt { "昵称" }
        dd { @user.nickname }
        dt { "邮箱" }
        dd { @user.email }
        dt { "在线状态" }
        dd do
          if @user.online_status
            span(class: "item-badge") { "在线" }
          else
            span(class: "item-tag") { "离线" }
          end
        end
      end
    end

    div(class: "actions") do
      a(href: "/users", class: "mc-btn") { "返回" }
      a(href: "/users/#{@user.id}/edit", class: "mc-btn mc-btn-accent") { "编辑" }
    end
  end
end
