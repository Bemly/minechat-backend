class Rooms::Show < ApplicationView
  def initialize(room:, messages: [])
    @room = room
    @messages = messages
  end

  def content
    div(class: "show-container") do
      # 房间头部信息
      div(class: "room-header ore-card") do
        div(class: "room-icon-large") { "🏠" }
        div(class: "room-header-info") do
          h1(class: "room-display-name") { @room.name || "未命名" }
          if @room.room_type.present?
            div(class: "room-type-badge") { @room.room_type }
          end
        end
      end

      # 房间消息
      div(class: "ore-card messages-card") do
        h2 { "消息 (#{@messages.count})" }
        if @messages.any?
          div(class: "messages-list") do
            @messages.each do |msg|
              div(class: "message-item") do
                div(class: "message-header") do
                  span(class: "message-sender") { "用户 #{msg.sender_id}" }
                  span(class: "message-time") { msg.timestamp }
                end
                div(class: "message-content") { msg.content }
              end
            end
          end
        else
          div(class: "empty-messages") do
            div { "💬" }
            p { "暂无消息" }
          end
        end
      end

      # 操作按钮
      div(class: "actions wide-actions") do
        a(href: "/rooms", class: "mc-btn") { "← 返回列表" }
        a(href: "/rooms/#{@room.id}/edit", class: "mc-btn mc-btn-accent") { "✏️ 编辑" }
      end
    end

    style { safe(ROOMS_SHOW_CSS) }
  end

  ROOMS_SHOW_CSS = <<~CSS
    .show-container {
      max-width: 700px;
      margin: 0 auto;
    }

    .room-header {
      display: flex;
      align-items: center;
      gap: 24px;
      padding: 32px;
      margin-bottom: 16px;
    }

    .room-icon-large {
      width: 80px;
      height: 80px;
      background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
      border: 2px solid var(--mc-border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 2.5rem;
      flex-shrink: 0;
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.4), 4px 4px 12px rgba(0,0,0,0.2);
    }

    .room-header-info {
      flex: 1;
      min-width: 0;
    }

    .room-display-name {
      text-align: left;
      font-size: clamp(1.4rem, 3vw, 1.8rem);
      margin-bottom: 8px;
      color: var(--mc-text);
      text-shadow: none;
    }

    .room-type-badge {
      display: inline-block;
      padding: 6px 16px;
      border: 2px solid var(--mc-border);
      background: #3a3b3e;
      color: var(--mc-text);
      font-weight: 700;
    }

    .messages-card {
      padding: 28px 32px;
    }

    .messages-list {
      display: flex;
      flex-direction: column;
      gap: 12px;
      margin-top: 16px;
    }

    .message-item {
      padding: 14px 18px;
      background: #3a3b3e;
      border: 2px solid var(--mc-border);
    }

    .message-header {
      display: flex;
      justify-content: space-between;
      align-items: center;
      margin-bottom: 8px;
    }

    .message-sender {
      color: var(--mc-accent-hover);
      font-weight: 700;
    }

    .message-time {
      color: var(--mc-muted);
      font-size: 0.85rem;
    }

    .message-content {
      color: var(--mc-text);
      line-height: 1.4;
    }

    .empty-messages {
      text-align: center;
      padding: 32px 20px;
      color: var(--mc-muted);
    }

    .empty-messages div {
      font-size: 3rem;
      margin-bottom: 12px;
    }

    .empty-messages p {
      margin: 0;
    }

    .wide-actions {
      justify-content: center;
      padding-top: 8px;
    }

    h2 {
      margin-top: 0;
    }

    @media (max-width: 640px) {
      .room-header {
        flex-direction: column;
        text-align: center;
        padding: 24px;
      }

      .room-icon-large {
        width: 60px;
        height: 60px;
        font-size: 2rem;
      }

      .room-display-name {
        text-align: center;
      }

      .messages-card {
        padding: 20px;
      }

      .message-item {
        padding: 12px 14px;
      }
    }
  CSS
end
