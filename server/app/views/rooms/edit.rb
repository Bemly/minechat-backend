class Rooms::Edit < ApplicationView
  def initialize(room:, errors: [])
    @room = room
    @errors = errors
  end

  def view_template
    div(class: "container") do
      h1 { "编辑房间" }

      if @errors.any?
        ul(class: "flash-alert") do
          @errors.each { |e| li { e } }
        end
      end

      div(class: "card") do
        form(action: "/rooms/#{@room.id}", method: "post") do
          input(type: "hidden", name: "_method", value: "patch")
          div(class: "form-group") do
            label(for: "name") { "房间名称" }
            input(type: "text", id: "name", name: "room[name]", value: @room.name)
          end
          div(class: "form-group") do
            label(for: "room_type") { "类型" }
            input(type: "text", id: "room_type", name: "room[room_type]", value: @room.room_type)
          end
          button(type: "submit", class: "btn") { "更新" }
        end
      end

      div(class: "actions") do
        a(href: "/rooms", class: "btn") { "返回" }
      end
    end
  end
end
