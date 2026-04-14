class Rooms::Edit < ApplicationView
  def initialize(room:, errors: [])
    @room = room
    @errors = errors
  end

  def content
    h1 { "编辑房间" }

    if @errors.any?
      div(class: "flash-alert") do
        ul do
          @errors.each { |e| li { e } }
        end
      end
    end

    div(class: "mc-card") do
      form(action: "/rooms/#{@room.id}", method: "post", class: "mc-form") do
        input(type: "hidden", name: "_method", value: "patch")
        div(class: "form-group") do
          label(for: "name") { "房间名称" }
          input(type: "text", id: "name", name: "room[name]", value: @room.name)
        end
        div(class: "form-group") do
          label(for: "room_type") { "类型" }
          input(type: "text", id: "room_type", name: "room[room_type]", value: @room.room_type)
        end
        div(class: "actions") do
          button(type: "submit", class: "mc-btn mc-btn-accent") { "更新" }
          a(href: "/rooms", class: "mc-btn") { "返回" }
        end
      end
    end
  end
end
