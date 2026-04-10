class Rooms::Show < ApplicationView
  def initialize(room: {}, messages: [])
    @room = room
    @messages = messages
  end

  def view_template
    div(class: "container") do
      h1 { @room.dig("attributes", "name") || "房间详情" }

      div(class: "card") do
        dl do
          dt { "房间名称" }
          dd { @room.dig("attributes", "name") }
          dt { "类型" }
          dd { @room.dig("attributes", "room_type") }
        end
      end

      h2 { "消息" }
      if @messages.any?
        ul(class: "item-list") do
          @messages.each do |msg|
            li do
              strong { "#{msg.dig("attributes", "sender_id")}:" }
              span { msg.dig("attributes", "content") }
              small { "  #{msg.dig("attributes", "timestamp")}" }
            end
          end
        end
      else
        p { "暂无消息" }
      end

      div(class: "actions") do
        a(href: "/rooms", class: "btn") { "返回" }
      end
    end
  end
end
