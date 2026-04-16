class Rooms::New < ApplicationView
  def initialize(room: nil, errors: [])
    @room = room
    @errors = errors
  end

  def content
    div(class: "form-container") do
      h1 { "新建房间" }

      if @errors.any?
        div(class: "flash-alert ore-card") do
          div(class: "alert-icon") { "⚠" }
          ul(class: "alert-list") do
            @errors.each { |e| li { e } }
          end
        end
      end

      div(class: "ore-card form-card") do
        div(class: "form-header") do
          div(class: "form-icon") { "🏠" }
          div(class: "form-title") { "创建新房间" }
        end

        form(action: "/rooms", method: "post", class: "mc-form") do
          div(class: "form-group") do
            label(for: "name") do
              span { "房间名称" }
              span(class: "form-required") { "*" }
            end
            input(type: "text", id: "name", name: "room[name]", value: @room&.name, required: true, placeholder: "输入房间名称")
          end

          div(class: "form-group") do
            label(for: "room_type") { "类型" }
            input(type: "text", id: "room_type", name: "room[room_type]", value: @room&.room_type, placeholder: "例如：public, private")
          end

          div(class: "actions") do
            button(type: "submit", class: "mc-btn mc-btn-accent") { "创建房间" }
            a(href: "/rooms", class: "mc-btn") { "取消" }
          end
        end
      end
    end

    style { safe(ROOMS_NEW_CSS) }
  end

  ROOMS_NEW_CSS = <<~CSS
    .form-container {
      max-width: 500px;
      margin: 0 auto;
    }

    .form-card {
      padding: 28px 32px;
    }

    .form-header {
      display: flex;
      align-items: center;
      gap: 12px;
      margin-bottom: 24px;
      padding-bottom: 16px;
      border-bottom: 2px solid rgba(255, 255, 255, 0.15);
    }

    .form-icon {
      font-size: 2rem;
    }

    .form-title {
      font-size: 1.3rem;
      font-weight: 700;
      color: var(--mc-text);
    }

    .form-required {
      color: #ef4444;
      margin-left: 4px;
    }

    .alert-list {
      margin: 0;
      padding-left: 20px;
    }

    .alert-list li {
      color: #ef4444;
      margin-bottom: 4px;
    }

    @media (max-width: 640px) {
      .form-card {
        padding: 20px;
      }

      .form-header {
        flex-direction: column;
        text-align: center;
      }
    }
  CSS
end
