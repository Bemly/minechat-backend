class Users::Index < ApplicationView
  def initialize(users: [])
    @users = users
  end

  def view_template
    div(class: "container") do
      h1 { "用户列表" }
      a(href: "/users/new", class: "btn") { "新建用户" }

      if @users.any?
        ul(class: "item-list") do
          @users.each do |user|
            li do
              span { user.dig("attributes", "nickname") || user.dig("attributes", "username") || "未知" }
              span do
                a(href: "/users/#{user["id"]}", class: "btn") { "查看" }
                a(href: "/users/#{user["id"]}/edit", class: "btn") { "编辑" }
              end
            end
          end
        end
      end
    end
  end
end
