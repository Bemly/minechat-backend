class Rooms::New < ApplicationView
  def initialize(room: nil, errors: [])
    @room = room
    @errors = errors
  end

  def content
    h1 { "新建房间" }

    if @errors.any?
      div(class: "flash-alert") do
        ul do
          @errors.each { |e| li { e } }
        end
      end
    end

    div(class: "mc-card") do
      form(action: "/rooms", method: "post", class: "mc-form") do
        div(class: "form-group") do
          label(for: "name") { "房间名称" }
          input(type: "text", id: "name", name: "room[name]", value: @room&.name)
        end
        div(class: "form-group") do
          label(for: "room_type") { "类型" }
          input(type: "text", id: "room_type", name: "room[room_type]", value: @room&.room_type)
        end
        div(class: "actions") do
          button(type: "submit", class: "mc-btn mc-btn-accent") { "创建" }
          a(href: "/rooms", class: "mc-btn") { "返回" }
        end
      end
    end
  end
end
