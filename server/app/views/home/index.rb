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
            svg(class: "card-icon", viewBox: "0 0 100 100", overflow: "visible") do
              # 底部泥土基座
              path(d: "M50 85 L85 65 L85 40 L50 60 L15 40 L15 65 Z", fill: "#79553a", stroke: "#4a3322", stroke_width: "2")
              path(d: "M50 85 L85 65 L50 60 Z", fill: "#60422c", stroke: "#4a3322", stroke_width: "2")
              # 顶层草地
              path(d: "M50 20 L85 40 L50 60 L15 40 Z", fill: "#5c9a3b", stroke: "#3b6b21", stroke_width: "2")
              path(d: "M15 40 L50 60 L50 65 L15 45 Z", fill: "#4d8230")
              path(d: "M85 40 L50 60 L50 65 L85 45 Z", fill: "#3b6b21")
              # 高地石块
              path(d: "M35 15 L55 25 L35 35 L15 25 Z", fill: "#e0e0e0", stroke: "#999", stroke_width: "1")
              path(d: "M15 25 L35 35 L35 50 L15 40 Z", fill: "#a0a0a0", stroke: "#777", stroke_width: "1")
              path(d: "M55 25 L35 35 L35 50 L55 40 Z", fill: "#c0c0c0", stroke: "#777", stroke_width: "1")
              # 树木
              rect(x: "70", y: "30", width: "4", height: "10", fill: "#5c4033")
              path(d: "M65 25 L77 25 L77 35 L65 35 Z", fill: "#2d5a1e")
            end
            div(class: "waterfall-overflow")
          end
          span(class: "menu-label text-white") { "PLAY" }
        end

        # STORE 卡片 - 新建房间
        a(href: "/rooms/new", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            svg(class: "card-icon", viewBox: "0 0 100 100") do
              # 箱体侧面/前面
              path(d: "M50 85 L85 65 L85 35 L50 55 L15 35 L15 65 Z", fill: "#a06030", stroke: "#301505", stroke_width: "3")
              path(d: "M50 85 L85 65 L50 55 Z", fill: "#7a4520", stroke: "#301505", stroke_width: "3")
              # 箱子顶部
              path(d: "M50 15 L85 35 L50 55 L15 35 Z", fill: "#c47a3f", stroke: "#301505", stroke_width: "3")
              # 黑色镶边与锁扣
              path(d: "M15 40 L50 60 L85 40", fill: "none", stroke: "#222", stroke_width: "4")
              rect(x: "46", y: "52", width: "8", height: "12", fill: "#c0c0c0", stroke: "#333", stroke_width: "2")
              # + 符号
              text(x: "30", y: "75", fill: "#fff", font_size: "20", font_weight: "bold") { "+" }
            end
          end
          span(class: "menu-label") { "STORE" }
        end

        # SKINS 卡片 - 用户
        a(href: "/users", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            svg(class: "card-icon", viewBox: "0 0 100 100") do
              # Steve (右侧)
              g(transform: "translate(15, -5)") do
                path(d: "M50 75 L75 60 L75 35 L50 50 L25 35 L25 60 Z", fill: "#b07e60", stroke: "#333", stroke_width: "2")
                path(d: "M50 75 L75 60 L50 50 Z", fill: "#906040", stroke: "#333", stroke_width: "2")
                path(d: "M50 20 L75 35 L50 50 L25 35 Z", fill: "#4a3018", stroke: "#333", stroke_width: "2")
                path(d: "M25 35 L50 50 L50 55 L25 40 Z", fill: "#4a3018")
              end
              # Alex (左侧)
              g(transform: "translate(-15, 15)") do
                path(d: "M50 75 L75 60 L75 35 L50 50 L25 35 L25 60 Z", fill: "#f0b590", stroke: "#333", stroke_width: "2")
                path(d: "M50 75 L75 60 L50 50 Z", fill: "#d09570", stroke: "#333", stroke_width: "2")
                path(d: "M50 20 L75 35 L50 50 L25 35 Z", fill: "#e07a20", stroke: "#333", stroke_width: "2")
                path(d: "M25 35 L50 50 L50 60 L25 45 Z", fill: "#e07a20")
              end
            end
          end
          span(class: "menu-label") { "USERS" }
        end

        # SETTINGS 卡片 - 新建用户
        a(href: "/users/new", class: "menu-card-wrapper") do
          div(class: "menu-card") do
            svg(class: "card-icon", viewBox: "0 0 100 100") do
              # 石质底座1
              path(d: "M30 70 L50 60 L50 45 L30 55 Z", fill: "#888", stroke: "#333", stroke_width: "2")
              path(d: "M30 55 L50 45 L40 40 L20 50 Z", fill: "#aaa", stroke: "#333", stroke_width: "2")
              path(d: "M50 70 L70 60 L70 45 L50 55 Z", fill: "#666", stroke: "#333", stroke_width: "2")
              path(d: "M50 55 L70 45 L60 40 L40 50 Z", fill: "#aaa", stroke: "#333", stroke_width: "2")
              # 拉杆柄
              path(d: "M45 45 L70 20 L75 25 L50 50 Z", fill: "#a05a2c", stroke: "#333", stroke_width: "2")
              # 红石粉点缀
              circle(cx: "45", cy: "60", r: "3", fill: "#ff0000")
              circle(cx: "55", cy: "55", r: "2", fill: "#ff0000")
              # + 符号
              text(x: "30", y: "75", fill: "#fff", font_size: "20", font_weight: "bold") { "+" }
            end
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
    const bubblesContainer = document.getElementById('bubbles-container');
    const bubbleCount = 30;

    for (let i = 0; i < bubbleCount; i++) {
      let bubble = document.createElement('div');
      bubble.classList.add('bubble');

      // bubble.style.width = `${Math.random() * 10 + 2}px`;
      bubble.style.height = `${Math.random() * 10 + 2}px`;
      bubble.style.left = `${Math.random() * 100}vw`;
      bubble.style.animationDuration = `${Math.random() * 10 + 10}s`;
      bubble.style.animationDelay = `${Math.random() * 15}s`;

      bubblesContainer.appendChild(bubble);
    }
  JS
end
