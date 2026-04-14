class ApplicationView < Phlex::HTML
  include Phlex::Rails

  def view_template(&)
    doctype
    html do
      head do
        title { "Minechat" }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        style { BASE_CSS }
      end
      body do
        nav { render NavBar }
        flash_messages
        div(&)
      end
    end
  end

  BASE_CSS = <<~CSS
    * { margin: 0; padding: 0; box-sizing: border-box; }
    body { font-family: -apple-system, sans-serif; background: #f5f5f5; color: #333; }
    nav { background: #2563eb; padding: 12px 20px; }
    nav a { color: #fff; text-decoration: none; margin-right: 16px; font-weight: 500; }
    nav a:hover { text-decoration: underline; }
    .container { max-width: 800px; margin: 20px auto; padding: 0 20px; }
    .card { background: #fff; border-radius: 8px; padding: 20px; margin: 16px 0; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
    .btn { display: inline-block; padding: 8px 16px; background: #2563eb; color: #fff; border: none; border-radius: 6px; text-decoration: none; cursor: pointer; font-size: 14px; }
    .btn:hover { background: #1d4ed8; }
    .btn-danger { background: #dc2626; }
    .btn-danger:hover { background: #b91c1c; }
    .flash-notice { background: #d1fae5; color: #065f46; padding: 10px; border-radius: 6px; margin: 10px 0; }
    .flash-alert { background: #fee2e2; color: #991b1b; padding: 10px; border-radius: 6px; margin: 10px 0; }
    .form-group { margin: 12px 0; }
    .form-group label { display: block; margin-bottom: 4px; font-weight: 500; }
    .form-group input, .form-group textarea { width: 100%; padding: 8px; border: 1px solid #d1d5db; border-radius: 6px; font-size: 14px; }
    .item-list { list-style: none; }
    .item-list li { padding: 12px; border-bottom: 1px solid #e5e7eb; display: flex; justify-content: space-between; align-items: center; }
    .item-list li:last-child { border-bottom: none; }
    h1 { margin-bottom: 16px; }
    dt { font-weight: 600; margin-top: 8px; }
    dd { margin-left: 0; color: #6b7280; }
    .actions { margin-top: 16px; }
    .actions a, .actions button { margin-right: 8px; }
  CSS

  class NavBar < Phlex::HTML
    def view_template
      a(href: "/") { "首页" }
      a(href: "/users") { "用户" }
      a(href: "/rooms") { "房间" }
    end
  end

  private

  def flash_messages
    if flash[:notice]
      div(class: "flash-notice") { flash[:notice] }
    end
    if flash[:alert]
      div(class: "flash-alert") { flash[:alert] }
    end
  end
end
