class Users::Index < ApplicationView
  def initialize(users: [])
    @users = users
  end

  def content
    h1 { "用户列表" }

    div(class: "actions", style: "justify-content: center; margin-bottom: 16px; margin-top: 0;") do
      a(href: "/users/new", class: "mc-btn mc-btn-accent") { "+ 新建用户" }
    end

    if @users.any?
      ul(class: "mc-list") do
        @users.each do |user|
          li do
            a(href: "/users/#{user.id}", class: "mc-list-item") do
              span(class: "item-name") { user.nickname || user.username || "未知" }
              span(class: "item-badge") { user.online_status ? "在线" : "离线" }
            end
          end
        end
      end
    else
      p(style: "color: var(--muted); padding: 20px 0; text-align: center;") { "暂无用户" }
    end
  end
end
