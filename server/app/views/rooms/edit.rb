class Rooms::Edit < ApplicationView
  def initialize(room:, errors: [])
    @room = room
    @errors = errors
  end

  def content
    div(class: "form-container") do
      h1 { "编辑房间" }

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
          div(class: "form-icon") { "✏️" }
          div(class: "form-title") { "编辑房间信息" }
          div(class: "form-subtitle") { @room.name }
        end

        form(action: "/rooms/#{@room.id}", method: "post", class: "mc-form") do
          input(type: "hidden", name: "_method", value: "patch")

          div(class: "form-group") do
            label(for: "name") do
              span { "房间名称" }
              span(class: "form-required") { "*" }
            end
            input(type: "text", id: "name", name: "room[name]", value: @room.name, required: true)
          end

          div(class: "form-group") do
            label(for: "room_type") { "类型" }
            input(type: "text", id: "room_type", name: "room[room_type]", value: @room.room_type)
          end

          div(class: "actions") do
            button(type: "submit", class: "mc-btn mc-btn-accent") { "更新房间" }
            a(href: "/rooms/#{@room.id}", class: "mc-btn") { "取消" }
          end
        end
      end
    end

    style { ROOMS_EDIT_CSS }
  end

  ROOMS_EDIT_CSS = <<~CSS
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
      border-bottom: 3px solid var(--mc-border);
    }

    .form-icon {
      font-size: 2rem;
    }

    .form-title {
      font-size: 1.3rem;
      font-weight: 700;
      color: #1a1a1a;
      text-shadow: 1px 1px 0 rgba(0,0,0,0.1);
    }

    .form-subtitle {
      margin-left: auto;
      font-size: 0.9rem;
      color: var(--mc-muted);
      padding: 4px 10px;
      border: 2px solid var(--mc-border);
      background: rgba(240, 240, 240, 0.6);
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

      .form-subtitle {
        margin-left: 0;
        margin-top: 8px;
      }
    }
  CSS
end
