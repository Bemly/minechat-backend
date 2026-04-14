class Home::Index < ApplicationView
  def initialize(rooms: [], users: [])
    @rooms = rooms
    @users = users
  end

  def view_template
    div(class: "container") do
      h1 { "Minechat" }

      h2 { "房间" }
      if @rooms.any?
        ul(class: "item-list") do
          @rooms.each do |room|
            li do
              a(href: "/rooms/#{room.id}") { room.name || "未命名" }
            end
          end
        end
      else
        p { "暂无房间。请先连接后端服务。" }
      end

      h2 { "用户" }
      if @users.any?
        ul(class: "item-list") do
          @users.each do |user|
            li { user.nickname || user.username || "未知" }
          end
        end
      else
        p { "暂无用户。" }
      end
    end
  end
end
