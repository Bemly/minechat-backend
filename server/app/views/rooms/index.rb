class Rooms::Index < ApplicationView
  def initialize(rooms: [])
    @rooms = rooms
  end

  def content
    h1 { "房间列表" }

    div(class: "actions", style: "justify-content: center; margin-bottom: 24px; margin-top: 0;") do
      a(href: "/rooms/new", class: "mc-btn mc-btn-accent") { "+ 新建房间" }
      a(href: "/", class: "mc-btn") { "← 返回" }
    end

    if @rooms.any?
      div(class: "card-grid") do
        @rooms.each do |room|
          a(href: "/rooms/#{room.id}") do
            div(class: "room-card ore-card") do
              div(class: "room-icon") { "🏠" }
              div(class: "room-info") do
                div(class: "room-name") { room.name || "未命名" }
                if room.room_type.present?
                  div(class: "room-type") { room.room_type }
                end
              end
              div(class: "room-arrow") { "→" }
            end
          end
        end
      end
    else
      div(class: "empty-state") do
        div(class: "empty-icon") { "🏗️" }
        p { "暂无房间" }
        p(style: "margin-top: 8px;") { "点击上方按钮创建第一个房间" }
      end
    end

    style { safe(ROOMS_INDEX_CSS) }
  end

  ROOMS_INDEX_CSS = <<~CSS
    .room-card {
      display: flex;
      align-items: center;
      padding: 16px 20px;
      gap: 16px;
      cursor: pointer;
      text-decoration: none;
      min-height: 80px;
    }

    .room-card:hover {
      transform: translateY(-4px);
    }

    .room-card.active {
      background: var(--mc-bg-active);
      border-color: #000;
    }

    .room-icon {
      width: 50px;
      height: 50px;
      background: linear-gradient(135deg, #f59e0b 0%, #d97706 100%);
      border: 3px solid var(--mc-border);
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.8rem;
      flex-shrink: 0;
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.4);
    }

    .room-info {
      flex: 1;
      min-width: 0;
    }

    .room-name {
      font-size: 1.1rem;
      font-weight: 700;
      color: #1a1a1a;
      margin-bottom: 4px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    .room-type {
      font-size: 0.85rem;
      color: var(--mc-muted);
      padding: 2px 8px;
      border: 2px solid var(--mc-border);
      display: inline-block;
      background: rgba(240, 240, 240, 0.6);
    }

    .room-arrow {
      font-size: 1.5rem;
      color: #666;
      transition: transform 0.2s, color 0.2s;
    }

    .room-card:hover .room-arrow {
      transform: translateX(4px);
      color: #4ade80;
    }

    .empty-state {
      text-align: center;
      padding: 48px 20px;
      background: rgba(240, 240, 240, 0.6);
      border: 3px solid var(--mc-border);
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7);
    }

    .empty-icon {
      font-size: 3rem;
      margin-bottom: 16px;
    }

    .empty-state p {
      color: #d1d1d1;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
      margin: 0;
    }

    @media (max-width: 640px) {
      .card-grid {
        grid-template-columns: 1fr;
      }

      .room-card {
        padding: 12px 16px;
      }

      .room-icon {
        width: 40px;
        height: 40px;
        font-size: 1.4rem;
      }

      .room-name {
        font-size: 1rem;
      }
    }
  CSS
end
