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
          style { CSS }
        end
        body do
          div class: "container" do
            h1 { @code }
            h2 { @title }
            p { @message }
            a(href: "/", class: "btn") { "返回首页" }
          end
        end
      end
    end

    CSS = <<~CSS
      * { margin: 0; padding: 0; box-sizing: border-box; }
      body { font-family: -apple-system, sans-serif; background: #f5f5f5; color: #333; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
      .container { text-align: center; }
      h1 { font-size: 80px; color: #2563eb; margin-bottom: 8px; }
      h2 { font-size: 24px; margin-bottom: 12px; }
      p { color: #6b7280; margin-bottom: 24px; }
      .btn { display: inline-block; padding: 10px 24px; background: #2563eb; color: #fff; border-radius: 6px; text-decoration: none; }
      .btn:hover { background: #1d4ed8; }
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
