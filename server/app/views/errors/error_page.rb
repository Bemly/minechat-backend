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
      html do
        head do
          title { "#{@code} - #{@title}" }
          meta name: "viewport", content: "width=device-width,initial-scale=1"
          meta name: "theme-color", content: "#0d0e10"
          link(rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=VT323&display=swap")
          style { CSS }
        end
        body do
          div(class: "page-shell") do
            div(class: "content-panel mc-error") do
              div(class: "error-code") { @code }
              div(class: "error-title") { @title }
              p(class: "error-msg") { @message }
              a(href: "/", class: "mc-btn mc-btn-accent") { "返回首页" }
            end
          end
        end
      end
    end

    CSS = <<~CSS
      * { margin: 0; padding: 0; box-sizing: border-box; }
      :root {
        --bg: #121214;
        --text: #efebe7;
        --muted: #bfb6ae;
        --accent: #88bb55;
        --mc-btn: #737373;
        --mc-btn-light: #9d9d9d;
        --mc-btn-dark: #565656;
        --mc-btn-shadow: #3a3a3a;
      }
      body {
        font-family: 'VT323', 'Courier New', monospace;
        color: var(--text);
        background: #0d0e11;
        min-height: 100vh;
      }
      .page-shell {
        min-height: 100vh;
        display: flex;
        flex-direction: column;
        align-items: center;
        justify-content: center;
        padding: 20px;
      }
      .content-panel {
        width: min(500px, 100%);
        border: 2px solid rgb(80 88 104 / .3);
        background: #0e101499;
        border-radius: 4px;
        padding: 40px 32px;
        box-shadow: inset 0 1px #ffffff0a, 0 20px 50px #0006;
        backdrop-filter: blur(10px);
        -webkit-backdrop-filter: blur(10px);
      }
      .mc-error { text-align: center; }
      .error-code {
        font-size: clamp(4rem, 10vw, 7rem);
        color: var(--accent);
        text-shadow: 3px 3px 0 rgba(0, 0, 0, .6);
        line-height: 1;
      }
      .error-title {
        font-size: 1.4rem;
        color: var(--text);
        margin: 10px 0 6px;
        text-transform: uppercase;
        letter-spacing: .1em;
        text-shadow: 2px 2px 0 rgba(0, 0, 0, .5);
      }
      .error-msg {
        color: var(--muted);
        margin-bottom: 24px;
        font-size: 1.1rem;
      }
      .mc-btn {
        display: inline-block;
        padding: 8px 18px;
        font-family: inherit;
        font-size: 1rem;
        font-weight: 700;
        color: var(--text);
        background: var(--mc-btn);
        border: 2px solid;
        border-color: var(--mc-btn-light) var(--mc-btn-dark) var(--mc-btn-dark) var(--mc-btn-light);
        border-radius: 2px;
        text-decoration: none;
        cursor: pointer;
        text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
        box-shadow: 0 2px 0 var(--mc-btn-shadow);
        text-transform: uppercase;
        letter-spacing: .04em;
        transition: background .1s ease;
      }
      .mc-btn:hover { background: var(--mc-btn-light); color: var(--text); }
      .mc-btn-accent {
        background: #5a8a2e;
        border-color: #7ab044 #4a7024 #4a7024 #7ab044;
        box-shadow: 0 2px 0 #3a5a1a;
        color: #fff;
      }
      .mc-btn-accent:hover { background: #6a9a3e; color: #fff; }
    CSS
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
