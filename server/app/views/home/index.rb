class Home::Index < ApplicationView
  def initialize(rooms: [], users: [])
    @rooms = rooms
    @users = users
  end

  def content
    # 主菜单卡片区域
    div(class: "menu-grid-wrapper") do
      div(class: "menu-grid") do
        # PLAY 卡片
        a(href: "/rooms", class: "menu-card-wrapper") do
          div(class: "menu-card active") do
            render Icons::TerrainIcon.new
            div(class: "waterfall-overflow")
          end
          span(class: "menu-label text-white") { "PLAY" }
        end

        # STORE 卡片 - 新建房间
        a(href: "/rooms/new", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            render Icons::ChestIcon.new
          end
          span(class: "menu-label") { "STORE" }
        end

        # SKINS 卡片 - 用户
        a(href: "/users", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            render Icons::PlayersIcon.new
          end
          span(class: "menu-label") { "USERS" }
        end

        # SETTINGS 卡片 - 新建用户
        a(href: "/users/new", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            render Icons::LeverIcon.new
          end
          span(class: "menu-label") { "NEW USER" }
        end
      end
    end

    # 底部最近游玩
    div(class: "recent-section") do
      h3(class: "recent-title") { "RECENTLY PLAYED" }
      div(class: "recent-grid") do
        if @rooms.any?
          @rooms.first(4).each do |room|
            a(href: "/rooms/#{room.id}", class: "recent-card") do
              div(class: "recent-card-inner") do
                div(class: "recent-icon") { "🏠" }
                div(class: "recent-name") { room.name || "未命名" }
              end
            end
          end
        elsif @rooms.empty? && @users.empty?
          div(class: "recent-card") do
            div(class: "recent-card-inner") do
              div { "暂无房间" }
            end
          end
        end

        if @rooms.empty? && @users.any?
          @users.first(4).each do |user|
            div(class: "recent-card") do
              div(class: "recent-card-inner") do
                div(class: "recent-icon") { "👤" }
                div(class: "recent-name") { user.nickname || user.username || "未知" }
              end
            end
          end
        end
      end
    end

    style { HOME_CSS }
    script { BUBBLE_JS }
  end

  HOME_CSS = <<~CSS
    .menu-grid-wrapper {
      display: flex;
      justify-content: center;
      align-items: center;
      padding: clamp(20px, 5vh, 60px) 0;
    }

    .menu-grid {
      display: flex;
      gap: 16px;
      align-items: flex-end;
    }

    .menu-card-wrapper {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 12px;
      cursor: pointer;
      text-decoration: none;
    }

    .menu-card {
      width: min(140px, 18vw);
      height: min(170px, 22vw);
      background-color: var(--mc-bg-default);
      border: 3px solid var(--mc-border);
      position: relative;
      display: flex;
      justify-content: center;
      align-items: center;
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 4px 4px 10px rgba(0,0,0,0.3);
      transition: transform 0.2s cubic-bezier(0.34, 1.56, 0.64, 1);
    }

    .menu-card.active {
      background-color: var(--mc-bg-active);
      border-color: #000;
    }

    .menu-card-wrapper:hover .menu-card {
      transform: translateY(-10px) scale(1.05);
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 8px 12px 15px rgba(0,0,0,0.4);
    }

    .menu-card-wrapper:hover .menu-label {
      color: #fff;
      text-shadow: 2px 2px 0px rgba(0,0,0,0.8);
      transform: scale(1.05);
    }

    .menu-label {
      color: #d1d1d1;
      font-size: clamp(0.9rem, 1.3vw, 1rem);
      text-shadow: 1px 1px 0px #000;
      letter-spacing: 1px;
      transition: color 0.2s, text-shadow 0.2s, transform 0.2s;
    }

    .menu-label.text-white {
      color: #fff;
      text-shadow: 2px 2px 0px rgba(0,0,0,0.8);
    }

    /* 瀑布溢出效果 */
    .waterfall-overflow {
      position: absolute;
      bottom: -40px;
      right: 15%;
      width: 3px;
      height: 50px;
      background: linear-gradient(90deg, #3b82f6 0%, #60a5fa 100%);
      border: 2px solid #1e3a8a;
      border-top: none;
      z-index: 10;
    }

    /* 瀑布动画 */
    .active .waterfall-overflow {
      animation: waterfall-flow 1s infinite linear;
    }

    @keyframes waterfall-flow {
      0% { opacity: 0.8; transform: translateY(0); }
      50% { opacity: 1; }
      100% { opacity: 0.8; transform: translateY(5px); }
    }

    /* SVG 图标基础设置 */
    .card-icon {
      width: min(100px, 14vw);
      height: min(100px, 14vw);
      filter: drop-shadow(4px 4px 0px rgba(0,0,0,0.2));
      transform: translateY(-8px);
    }

    .active .card-icon {
      transform: translateY(-12px);
    }

    /* 最近游玩卡片 */
    .recent-card-inner {
      display: flex;
      flex-direction: column;
      align-items: center;
      gap: 8px;
      padding: 10px;
    }

    .recent-icon {
      font-size: 2rem;
    }

    .recent-name {
      font-size: 0.9rem;
      color: rgba(255,255,255,0.7);
      text-align: center;
    }

    .recent-card:hover .recent-name {
      color: rgba(255,255,255,1);
    }

    @media (max-width: 640px) {
      .menu-grid {
        flex-wrap: wrap;
        justify-content: center;
        align-items: center;
      }

      .menu-card {
        width: 100px;
        height: 130px;
      }

      .card-icon {
        width: 60px;
        height: 60px;
      }

      .menu-label {
        font-size: 0.75rem;
      }

      .recent-grid {
        grid-template-columns: 1fr;
      }
    }
  CSS

  BUBBLE_JS = <<~JS
    // 生成水下背景的粒子气泡
    const bubblesContainer = document.getElementById(`bubbles-container`);
    const bubbleCount = 30;

    for (let i = 0; i < bubbleCount; i++) {
      let bubble = document.createElement(`div`);
      bubble.classList.add(`bubble`);

      // bubble.style.width = `${Math.random() * 10 + 2}px`;
      bubble.style.height = `${Math.random() * 10 + 2}px`;
      bubble.style.left = `${Math.random() * 100}vw`;
      bubble.style.animationDuration = `${Math.random() * 10 + 10}s`;
      bubble.style.animationDelay = `${Math.random() * 15}s`;

      bubblesContainer.appendChild(bubble);
    }
  JS
end
