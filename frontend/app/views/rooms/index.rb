class Rooms::Index < ApplicationView
  def initialize(rooms: [])
    @rooms = rooms
  end

  def view_template
    div(class: "container") do
      h1 { "房间列表" }
      a(href: "/rooms/new", class: "btn") { "新建房间" }

      if @rooms.any?
        ul(class: "item-list") do
          @rooms.each do |room|
            li do
              a(href: "/rooms/#{room["id"]}") { room.dig("attributes", "name") || "未命名" }
              small { room.dig("attributes", "room_type") || "" }
            end
          end
        end
      end
    end
  end
end
