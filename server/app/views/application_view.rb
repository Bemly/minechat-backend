class ApplicationView < Phlex::HTML
  include Phlex::Rails

  def view_template
    doctype
    html(lang: "zh") do
      head do
        meta charset: "UTF-8"
        meta name: "viewport", content: "width=device-width, initial-scale=1.0"
        title { "Minechat - OreUI" }
        link(rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Silkscreen&display=swap")
        style { safe(BASE_CSS) }
      end
      body do
        div(class: "underwater-bg")
        div(class: "water-overlay")
        div(id: "bubbles-container", class: "bubbles-container")

        div(class: "page-shell") do
          header(class: "mc-header") { render Header }
          flash_messages
          div(class: "content-panel") { content }
        end
      end
    end
  end

  def content
    # Subclasses override this method
  end

  BASE_CSS = <<~CSS
    * { margin: 0; padding: 0; box-sizing: border-box; }

    :root {
      --mc-border: #1e1e1e;
      --mc-bg-default: #f0f0f0;
      --mc-bg-active: #4ade80;
      --mc-text-shadow: 2px 2px 0px rgba(0,0,0,0.7);
      --mc-text: #1a1a1a;
      --mc-muted: #666666;
    }

    body {
      font-family: 'Silkscreen', sans-serif;
      margin: 0;
      overflow: hidden;
      background-color: #0b4b6c;
      user-select: none;
      color: var(--mc-text);
      min-height: 100vh;
    }

    /* 动态水下背景 */
    .underwater-bg {
      position: absolute;
      top: 0;
      left: 0;
      width: 100vw;
      height: 100vh;
      background: linear-gradient(180deg, #1b6ca8 0%, #0b4b6c 50%, #062b3d 100%);
      z-index: -2;
      pointer-events: none;
    }

    /* 模拟水中的光影和雾气 */
    .water-overlay {
      position: absolute;
      top: 0; left: 0; width: 100%; height: 100%;
      background: radial-gradient(circle at 50% 30%, rgba(255,255,255,0.1) 0%, rgba(0,0,0,0.3) 80%);
      z-index: -1;
      pointer-events: none;
    }

    /* 页面容器 */
    .page-shell {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      padding: clamp(10px, 2.5vw, 20px);
      position: relative;
      overflow-y: auto;
      overflow-x: hidden;
    }

    /* 顶部 Header */
    .mc-header {
      position: relative;
      z-index: 10;
      width: min(900px, 100%);
      margin: 0 auto;
      display: flex;
      justify-content: space-between;
      align-items: flex-start;
      padding-top: clamp(8px, 2vh, 16px);
    }

    .mc-logo {
      font-size: clamp(2rem, 5vw, 4.5rem);
      color: #d1d1d1;
      text-align: center;
      letter-spacing: 2px;
      text-shadow:
        -2px -2px 0 #000, 2px -2px 0 #000, -2px 2px 0 #000, 2px 2px 0 #000,
        4px 4px 0px #000,
        0px 6px 0px rgba(0,0,0,0.5);
      transform: scaleY(0.9);
    }

    .mc-nav {
      display: flex;
      align-items: center;
      gap: 8px;
    }

    .mc-nav a {
      color: var(--mc-text);
      text-decoration: none;
      font-size: clamp(0.9rem, 1.2vw, 1rem);
      font-weight: 700;
      padding: 6px 14px;
      text-transform: uppercase;
      letter-spacing: .06em;
      transition: color .12s ease;
    }

    .mc-nav a:hover { color: #4ade80; }

    .mc-nav .nav-logo {
      font-size: 1.2rem;
      color: #4ade80;
      margin-right: auto;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, .6);
      letter-spacing: .08em;
    }

    /* Content panel */
    .content-panel {
      position: relative;
      z-index: 10;
      width: min(900px, 100%);
      margin: 12px auto;
      flex: 1;
    }

    /* 漂浮的粒子/气泡 */
    .bubble {
      position: fixed;
      background: rgba(255, 255, 255, 0.15);
      border-radius: 50%;
      animation: float-up infinite linear;
      pointer-events: none;
      z-index: 0;
    }

    @keyframes float-up {
      0% { transform: translateY(100vh) scale(1); opacity: 0; }
      10% { opacity: 1; }
      90% { opacity: 1; }
      100% { transform: translateY(-10vh) scale(1.5); opacity: 0; }
    }

    /* Headings */
    h1 {
      text-align: center;
      font-size: clamp(1.4rem, 3vw, 2rem);
      color: #d1d1d1;
      margin-bottom: clamp(12px, 2vh, 20px);
      text-shadow: var(--mc-text-shadow);
      text-transform: uppercase;
      letter-spacing: .1em;
    }

    h2 {
      font-size: clamp(1rem, 2vw, 1.3rem);
      color: #d1d1d1;
      margin: 16px 0 12px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .8);
      text-transform: uppercase;
      letter-spacing: .08em;
      border-bottom: 3px solid rgba(30, 30, 30, 0.6);
      padding-bottom: 8px;
    }

    h3 {
      font-size: 1rem;
      color: #4ade80;
      margin: 12px 0 8px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .8);
    }

    /* Links */
    a {
      color: #4ade80;
      text-decoration: none;
      transition: color .12s ease;
    }
    a:hover { color: #22c55e; }

    /* Minecraft-style button */
    .mc-btn {
      display: inline-block;
      padding: 8px 18px;
      font-family: inherit;
      font-size: 1rem;
      font-weight: 700;
      color: #1a1a1a;
      background: var(--mc-bg-default);
      border: 3px solid var(--mc-border);
      text-decoration: none;
      cursor: pointer;
      text-shadow: 1px 1px 0 rgba(255, 255, 255, .5);
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 4px 4px 10px rgba(0,0,0,0.3);
      text-transform: uppercase;
      letter-spacing: .04em;
      transition: transform 0.1s, filter 0.1s;
    }
    .mc-btn:hover {
      filter: brightness(0.95);
      transform: translateY(-2px);
    }
    .mc-btn:active {
      transform: translateY(1px);
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 2px 2px 5px rgba(0,0,0,0.3);
    }

    /* Green accent button */
    .mc-btn-accent {
      background: #4ade80;
      color: #1a1a1a;
    }
    .mc-btn-accent:hover {
      background: #22c55e;
    }

    /* Red danger button */
    .mc-btn-danger {
      background: #ef4444;
      border-color: #b91c1c;
    }
    .mc-btn-danger:hover {
      background: #dc2626;
    }

    /* OreUI 风格卡片 */
    .ore-card {
      background: var(--mc-bg-default);
      border: 3px solid var(--mc-border);
      border-radius: 0;
      padding: 20px 24px;
      margin: 12px 0;
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 4px 4px 10px rgba(0,0,0,0.3);
      transition: transform 0.2s;
    }

    .ore-card:hover {
      transform: translateY(-4px);
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 6px 8px 16px rgba(0,0,0,0.4);
    }

    .ore-card.active {
      background: var(--mc-bg-active);
      border-color: #000;
    }

    /* 卡片网格 */
    .card-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(180px, 1fr));
      gap: 16px;
    }

    /* 顶部按钮风格 */
    .top-btn {
      background: white;
      border: 2px solid var(--mc-border);
      padding: 6px 14px;
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: clamp(0.8rem, 1.2vw, 0.9rem);
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.8);
      cursor: pointer;
      transition: transform 0.1s, filter 0.1s;
      text-decoration: none;
      color: #1a1a1a;
    }
    .top-btn:active {
      transform: scale(0.95);
    }
    .top-btn:hover {
      filter: brightness(0.9);
    }

    /* 最近游玩区域 */
    .recent-section {
      margin-top: 24px;
    }

    .recent-title {
      color: #d1d1d1;
      font-size: clamp(0.9rem, 1.4vw, 1rem);
      text-shadow: var(--mc-text-shadow);
      margin-bottom: 12px;
      padding-left: 4px;
    }

    .recent-grid {
      display: grid;
      grid-template-columns: repeat(auto-fill, minmax(220px, 1fr));
      gap: 12px;
    }

    .recent-card {
      width: 100%;
      height: 110px;
      background: #555;
      border: 2px solid var(--mc-border);
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.3), inset 2px 2px 0px rgba(255,255,255,0.2);
      overflow: hidden;
      display: flex;
      justify-content: center;
      align-items: center;
      color: rgba(255,255,255,0.5);
    }

    .recent-card:hover {
      color: rgba(255,255,255,0.8);
    }

    /* List items */
    .ore-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 8px;
    }

    .ore-list-item {
      display: flex;
      align-items: center;
      padding: 14px 18px;
      background: var(--mc-bg-default);
      border: 3px solid var(--mc-border);
      border-radius: 0;
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 2px 2px 6px rgba(0,0,0,0.2);
      transition: transform 0.12s, box-shadow 0.12s;
      text-decoration: none;
      color: var(--mc-text);
      gap: 12px;
    }

    .ore-list-item:hover {
      transform: translateY(-2px);
      box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 4px 6px 12px rgba(0,0,0,0.3);
      border-color: #4ade80;
    }

    .ore-list-item .item-name {
      flex: 1;
      font-weight: 700;
    }

    .ore-list-item .item-tag {
      flex-shrink: 0;
      padding: 4px 10px;
      font-size: 0.85rem;
      color: var(--mc-muted);
      border: 2px solid var(--mc-border);
    }

    .ore-list-item .item-badge {
      flex-shrink: 0;
      padding: 6px 12px;
      font-size: 0.85rem;
      font-weight: 700;
      color: #1a1a1a;
      background: #4ade80;
      border: 2px solid var(--mc-border);
    }

    /* Forms */
    .mc-form .form-group {
      margin: 16px 0;
    }

    .mc-form label {
      display: block;
      margin-bottom: 8px;
      font-weight: 700;
      font-size: 0.95rem;
      color: #d1d1d1;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
      text-transform: uppercase;
      letter-spacing: .04em;
    }

    .mc-form input,
    .mc-form textarea,
    .mc-form select {
      width: 100%;
      border: 3px solid var(--mc-border);
      border-radius: 0;
      padding: 12px 16px;
      font-size: 1rem;
      font-family: inherit;
      color: #1a1a1a;
      background: var(--mc-bg-default);
      outline: none;
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7);
      transition: border-color .16s ease;
    }

    .mc-form input:focus,
    .mc-form textarea:focus,
    .mc-form select:focus {
      border-color: #4ade80;
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7), 0 0 0 3px rgba(74, 222, 128, 0.3);
    }

    /* Flash messages */
    .flash-notice {
      position: relative;
      z-index: 10;
      width: min(900px, 100%);
      margin: 8px auto;
      background: rgba(74, 222, 128, 0.2);
      border: 3px solid #4ade80;
      color: #4ade80;
      padding: 14px 18px;
      font-weight: 700;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7);
    }

    .flash-alert {
      position: relative;
      z-index: 10;
      width: min(900px, 100%);
      margin: 8px auto;
      background: rgba(239, 68, 68, 0.2);
      border: 3px solid #ef4444;
      color: #ef4444;
      padding: 14px 18px;
      font-weight: 700;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7);
    }

    /* Actions row */
    .actions {
      margin-top: 24px;
      display: flex;
      gap: 12px;
      flex-wrap: wrap;
    }

    /* Messages */
    .mc-message {
      padding: 14px 18px;
      background: rgba(240, 240, 240, 0.8);
      border: 3px solid var(--mc-border);
      margin-bottom: 8px;
      box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.7);
    }

    .mc-message .msg-sender {
      color: #4ade80;
      font-weight: 700;
      margin-right: 10px;
    }

    .mc-message .msg-content {
      color: #1a1a1a;
    }

    .mc-message .msg-time {
      color: var(--mc-muted);
      font-size: 0.85rem;
      margin-left: 10px;
    }

    /* Card detail */
    .ore-card dt {
      font-weight: 700;
      color: #4ade80;
      margin-top: 14px;
      text-transform: uppercase;
      font-size: 0.9rem;
      letter-spacing: .06em;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, 0.8);
    }
    .ore-card dt:first-child { margin-top: 0; }
    .ore-card dd {
      margin-left: 0;
      color: #1a1a1a;
      padding: 6px 0;
      font-size: 1.05rem;
    }

    /* Error page */
    .mc-error {
      text-align: center;
      padding: 60px 20px;
    }

    .mc-error .error-code {
      font-size: clamp(4rem, 12vw, 8rem);
      color: #4ade80;
      text-shadow: var(--mc-text-shadow);
      line-height: 1;
    }

    .mc-error .error-title {
      font-size: clamp(1.4rem, 3vw, 2rem);
      color: #d1d1d1;
      margin: 16px 0 12px;
      text-transform: uppercase;
      letter-spacing: .1em;
      text-shadow: var(--mc-text-shadow);
    }

    .mc-error .error-msg {
      color: rgba(209, 209, 209, 0.7);
      margin-bottom: 32px;
    }

    /* Responsive */
    @media (max-width: 640px) {
      .mc-header { flex-wrap: wrap; gap: 12px; justify-content: center; }
      ._mc-nav { order: 2; width: 100%; justify-content: center; }
      .card-grid { grid-template-columns: repeat(auto-fill, minmax(140px, 1fr)); }
    }
  CSS

  class Header < Phlex::HTML
    def view_template
      div(class: "top-btn") do
        span(class: "text-blue-600 font-bold text-lg bg-gray-200 border border-gray-400 w-5 h-5 flex items-center justify-center") { "?" }
        plain "Help"
      end

      div(class: "mc-logo") { "MINECHAT" }

      div(class: "mc-nav") do
        a(href: "/", class: "nav-logo") { "⛏" }
        a(href: "/users") { "用户" }
        a(href: "/rooms") { "房间" }
      end
    end
  end

  private

  def flash_messages
    if helpers.flash[:notice]
      div(class: "flash-notice") do
        ul do
          Array(helpers.flash[:notice]).each { |msg| li { msg } }
        end
      end
    end
    if helpers.flash[:alert]
      div(class: "flash-alert") do
        ul do
          Array(helpers.flash[:alert]).each { |msg| li { msg } }
        end
      end
    end
  end
end
