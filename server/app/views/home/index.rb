class Home::Index < ApplicationView
  def initialize(rooms: [], users: [])
    @rooms = rooms
    @users = users
  end

  def content
    div(class: "mc-hero") do
      h1 { "⛏ Minechat" }
      p(class: "mc-subtitle") { "Ruby 聊天应用 — 纯 Ruby，零 JavaScript" }
    end

    h2 { "房间" }
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
      p(class: "mc-empty") { "暂无房间。请先连接后端服务。" }
    end

    h2 { "用户" }
    if @users.any?
      ul(class: "mc-list") do
        @users.each do |user|
          li do
            a(href: "/users/#{user.id}", class: "mc-list-item") do
              span(class: "item-name") { user.nickname || user.username || "未知" }
              span(class: "item-badge") { user.online_status ? "在线" : "离线" }
            end
          end
        end
      end
    else
      p(class: "mc-empty") { "暂无用户。" }
    end

    style { HERO_CSS }
  end

  HERO_CSS = <<~CSS
    .mc-hero {
      text-align: center;
      padding: 12px 0 8px;
    }
    .mc-hero h1 {
      font-size: clamp(2rem, 4vw, 3rem);
      color: var(--accent);
      text-shadow: 3px 3px 0 rgba(0, 0, 0, .6);
      letter-spacing: .12em;
      margin-bottom: 6px;
    }
    .mc-subtitle {
      color: var(--muted);
      font-size: 1rem;
      text-transform: uppercase;
      letter-spacing: .2em;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }
    .mc-empty {
      color: var(--muted);
      padding: 12px 0;
      font-style: italic;
    }
  CSS
end
