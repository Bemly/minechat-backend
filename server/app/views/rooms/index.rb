class Rooms::Index < ApplicationView
  def initialize(rooms: [])
    @rooms = rooms
  end

  def content
    h1 { "房间列表" }

    div(class: "actions", style: "justify-content: center; margin-bottom: 16px; margin-top: 0;") do
      a(href: "/rooms/new", class: "mc-btn mc-btn-accent") { "+ 新建房间" }
    end

    if @rooms.any?
      ul(class: "mc-list") do
        @rooms.each do |room|
          li do
            a(href: "/rooms/#{room.id}", class: "mc-list-item") do
              span(class: "item-name") { room.name || "未命名" }
              if room.room_type.present?
                span(class: "item-tag") { room.room_type }
              end
            end
          end
        end
      end
    else
      p(class: "mc-empty", style: "color: var(--muted); padding: 20px 0; text-align: center;") do
        "暂无房间"
      end
    end
  end
end
