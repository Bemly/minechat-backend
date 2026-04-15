module Errors
  class ErrorPage < Phlex::HTML
    include Phlex::Rails

    def initialize(code:, title:, message:)
      @code = code
      @title = title
      @message = message
    end

    def view_template
      doctype
      html(lang: "zh") do
        head do
          title { "#{@code} - #{@title}" }
          meta name: "viewport", content: "width=device-width, initial-scale=1.0"
          link(rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=Silkscreen&display=swap")
          style { CSS }
        end
        body do
          div(class: "underwater-bg")
          div(class: "water-overlay")
          div(id: "bubbles-container", class: "bubbles-container")

          div(class: "page-shell") do
            header(class: "mc-header") do
              a(href: "/", class: "top-btn") { "← 返回首页" }
              div(class: "mc-logo") { "MINECHAT" }
              div { "" }  # Spacing
            end

            div(class: "content-panel mc-error") do
              div(class: "error-icon") { "❌" }
              div(class: "error-code") { @code }
              div(class: "error-title") { @title }
              p(class: "error-msg") { @message }
              div(class: "error-actions") do
                a(href: "/", class: "mc-btn mc-btn-accent") { "返回首页" }
              end
            end
          end

          script { BUBBLE_JS }
        end
      end
    end

    CSS = <<~CSS
      * { margin: 0; padding: 0; box-sizing: border-box; }

      :root {
        --mc-border: #1e1e1e;
        --mc-bg-default: #f0f0f0;
        --mc-bg-active: #4ade80;
        --mc-text-shadow: 2px 2px 0px rgba(0,0,0,0.7);
      }

      body {
        font-family: 'Silkscreen', sans-serif;
        margin: 0;
        overflow: hidden;
        background-color: #0b4b6c;
        user-select: none;
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

      /* 顶部按钮风格 */
      .top-btn {
        background: white;
        border: 2px solid var(--mc-border);
        padding: 6px 14px;
        display: inline-block;
        font-size: clamp(0.8rem, 1.2vw, 0.9rem);
        box-shadow: inset -2px -2px 0px rgba(0,0,0,0.1), inset 2px 2px 0px rgba(255,255,255,0.8);
        cursor: pointer;
        text-decoration: none;
        color: #1a1a1a;
        transition: transform 0.1s;
      }
      .top-btn:active { transform: scale(0.95); }
      .top-btn:hover { filter: brightness(0.9); }

      /* Content panel */
      .content-panel {
        position: relative;
        z-index: 10;
        width: min(500px, 100%);
        margin: 20px auto;
        flex: 1;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 48px 32px;
        background: rgba(240, 240, 240, 0.6);
        border: 3px solid var(--mc-border);
        box-shadow: inset -3px -3px 0px rgba(0,0,0,0.1), inset 3px 3px 0px rgba(255,255,255,0.7), 4px 4px 16px rgba(0,0,0,0.3);
      }

      .mc-error { text-align: center; }

      .error-icon {
        font-size: 4rem;
        margin-bottom: 16px;
      }

      .error-code {
        font-size: clamp(4rem, 10vw, 6rem);
        color: #4ade80;
        text-shadow: var(--mc-text-shadow);
        line-height: 1;
        margin-bottom: 16px;
      }

      .error-title {
        font-size: clamp(1.4rem, 3vw, 1.8rem);
        color: #d1d1d1;
        margin: 8px 0 16px;
        text-transform: uppercase;
        letter-spacing: .1em;
        text-shadow: var(--mc-text-shadow);
      }

      .error-msg {
        color: rgba(209, 209, 209, 0.7);
        margin-bottom: 32px;
        font-size: 1rem;
        line-height: 1.5;
      }

      .error-actions {
        display: flex;
      }

      .mc-btn {
        display: inline-block;
        padding: 10px 24px;
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

      .mc-btn-accent {
        background: #4ade80;
      }
      .mc-btn-accent:hover {
        background: #22c55e;
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

      @media (max-width: 640px) {
        .mc-header { flex-wrap: wrap; gap: 12px; justify-content: center; }
        .content-panel { padding: 32px 20px; }
      }
    CSS

    BUBBLE_JS = <<~JS
      // 生成水下背景的粒子气泡
      const bubblesContainer = document.getElementById('bubbles-container');
      const bubbleCount = 20;
      for (let i = 0; i < bubbleCount; i++) {
        let bubble = document.createElement('div');
        bubble.classList.add('bubble');
        bubble.style.width = `${Math.random() * 10 + 2}px`;
        bubble.style.height = `${Math.random() * 10 + 2}px`;
        bubble.style.left = `${Math.random() * 100}vw`;
        bubble.style.animationDuration = `${Math.random() * 10 + 10}s`;
        bubble.style.animationDelay = `${Math.random() * 15}s`;
        bubblesContainer.appendChild(bubble);
      }
    JS
  end

  class NotFound < ErrorPage
    def initialize
      super(code: "404", title: "页面未找到", message: "抱歉，您访问的页面不存在")
    end
  end

  class UnprocessableEntity < ErrorPage
    def initialize
      super(code: "422", title: "请求无法处理", message: "抱歉，服务器无法处理您的请求")
    end
  end

  class InternalServerError < ErrorPage
    def initialize
      super(code: "500", title: "服务器错误", message: "抱歉，服务器遇到了一些问题，请稍后再试")
    end
  end
end
