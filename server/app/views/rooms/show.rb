class Rooms::Show < ApplicationView
  def initialize(room:, messages: [])
    @room = room
    @messages = messages
  end

  def content
    h1 { @room.name || "房间详情" }

    div(class: "mc-card") do
      dl do
        dt { "房间名称" }
        dd { @room.name }
        dt { "类型" }
        dd { @room.room_type }
      end
    end

    h2 { "消息" }
    if @messages.any?
      @messages.each do |msg|
        div(class: "mc-message") do
          span(class: "msg-sender") { "用户 #{msg.sender_id}" }
          span(class: "msg-content") { msg.content }
          span(class: "msg-time") { msg.timestamp }
        end
      end
    else
      p(style: "color: var(--muted); padding: 16px 0; text-align: center;") { "暂无消息" }
    end

    div(class: "actions") do
      a(href: "/rooms", class: "mc-btn") { "返回" }
      a(href: "/rooms/#{@room.id}/edit", class: "mc-btn mc-btn-accent") { "编辑" }
    end
  end
end
