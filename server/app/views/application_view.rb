class ApplicationView < Phlex::HTML
  include Phlex::Rails

  def view_template
    doctype
    html do
      head do
        title { "Minechat" }
        meta name: "viewport", content: "width=device-width,initial-scale=1"
        meta name: "theme-color", content: "#0d0e10"
        link(rel: "stylesheet", href: "https://fonts.googleapis.com/css2?family=VT323&display=swap")
        style { BASE_CSS }
      end
      body do
        div(class: "page-shell") do
          nav(class: "mc-nav") { render NavBar }
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
      --bg: #121214;
      --bg-2: #1a1b1f;
      --panel: rgb(23 25 30 / .55);
      --stone: #c3bcb5;
      --text: #efebe7;
      --muted: #bfb6ae;
      --line: rgb(65 71 84 / .4);
      --accent: #88bb55;
      --accent-2: #709944;
      --danger: #ff7d7d;
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
      overflow-y: auto;
      scrollbar-width: none;
      font-size: 18px;
    }
    body::-webkit-scrollbar { display: none; }

    .page-shell {
      min-height: 100vh;
      display: flex;
      flex-direction: column;
      align-items: center;
      padding: clamp(10px, 2.5vw, 20px);
      position: relative;
      overflow: hidden;
    }

    /* Minecraft dirt block texture pattern overlay */
    .page-shell::before {
      content: "";
      position: fixed;
      top: 0; right: 0; bottom: 0; left: 0;
      background-image:
        repeating-linear-gradient(
          0deg,
          transparent,
          transparent 3px,
          rgba(139, 119, 80, 0.015) 3px,
          rgba(139, 119, 80, 0.015) 4px
        ),
        repeating-linear-gradient(
          90deg,
          transparent,
          transparent 3px,
          rgba(139, 119, 80, 0.015) 3px,
          rgba(139, 119, 80, 0.015) 4px
        );
      pointer-events: none;
      z-index: 0;
    }

    /* Navigation */
    .mc-nav {
      position: relative;
      z-index: 2;
      width: min(920px, 100%);
      display: flex;
      align-items: center;
      gap: 6px;
      padding: 12px 16px;
      margin-top: clamp(10px, 3vh, 32px);
      background: #0e101499;
      border: 2px solid rgb(80 88 104 / .3);
      border-radius: 4px;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
      box-shadow: inset 0 1px #ffffff0a, 0 20px 50px #0006;
    }

    .mc-nav a {
      color: var(--stone);
      text-decoration: none;
      font-size: 1.1rem;
      font-weight: 700;
      padding: 6px 16px;
      border: 2px solid transparent;
      border-radius: 2px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
      text-transform: uppercase;
      letter-spacing: .06em;
      transition: color .12s ease, border-color .12s ease, background .12s ease;
    }

    .mc-nav a:hover {
      color: var(--accent);
      border-color: rgb(136 187 85 / .4);
      background: rgba(136, 187, 85, .08);
    }

    .mc-nav .nav-logo {
      font-size: 1.4rem;
      color: var(--accent);
      margin-right: auto;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, .6);
      letter-spacing: .08em;
    }

    .mc-nav .nav-logo:hover {
      color: #aadd66;
      border-color: transparent;
      background: none;
    }

    /* Content panel */
    .content-panel {
      position: relative;
      z-index: 1;
      width: min(920px, 100%);
      margin-top: 12px;
      border: 2px solid rgb(80 88 104 / .3);
      background: #0e101499;
      border-radius: 4px;
      padding: 24px clamp(14px, 3.5vw, 32px) 28px;
      box-shadow: inset 0 1px #ffffff0a, 0 20px 50px #0006;
      backdrop-filter: blur(10px);
      -webkit-backdrop-filter: blur(10px);
    }

    /* Headings */
    h1 {
      text-align: center;
      font-size: clamp(1.6rem, 3vw, 2.2rem);
      color: var(--text);
      margin-bottom: 18px;
      text-shadow: 2px 2px 0 rgba(0, 0, 0, .5);
      text-transform: uppercase;
      letter-spacing: .1em;
    }

    h2 {
      font-size: clamp(1.1rem, 2vw, 1.4rem);
      color: var(--stone);
      margin: 20px 0 10px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
      text-transform: uppercase;
      letter-spacing: .08em;
      border-bottom: 2px solid var(--line);
      padding-bottom: 6px;
    }

    h3 {
      font-size: 1.1rem;
      color: var(--accent);
      margin: 14px 0 8px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
    }

    /* Links */
    a {
      color: var(--accent);
      text-decoration: none;
      transition: color .12s ease;
    }
    a:hover { color: #aadd66; }

    /* Minecraft-style button */
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
      transition: background .1s ease, transform 80ms ease;
    }
    .mc-btn:hover {
      background: var(--mc-btn-light);
      color: var(--text);
    }
    .mc-btn:active {
      transform: translateY(1px);
      border-color: var(--mc-btn-dark) var(--mc-btn-light) var(--mc-btn-light) var(--mc-btn-dark);
      box-shadow: none;
    }

    /* Green accent button */
    .mc-btn-accent {
      background: #5a8a2e;
      border-color: #7ab044 #4a7024 #4a7024 #7ab044;
      box-shadow: 0 2px 0 #3a5a1a;
      color: #fff;
    }
    .mc-btn-accent:hover {
      background: #6a9a3e;
      color: #fff;
    }
    .mc-btn-accent:active {
      border-color: #4a7024 #7ab044 #7ab044 #4a7024;
    }

    /* Red danger button */
    .mc-btn-danger {
      background: #8b2020;
      border-color: #b04040 #6a1818 #6a1818 #b04040;
      box-shadow: 0 2px 0 #4a1010;
    }
    .mc-btn-danger:hover {
      background: #a03030;
      color: #fff;
    }
    .mc-btn-danger:active {
      border-color: #6a1818 #b04040 #b04040 #6a1818;
    }

    /* List items — repo-link-row style */
    .mc-list {
      list-style: none;
      display: flex;
      flex-direction: column;
      gap: 4px;
    }

    .mc-list-item {
      display: flex;
      align-items: center;
      gap: 12px;
      padding: 10px 14px;
      background: #3232328c;
      border: 2px solid rgb(80 80 80 / .45);
      border-radius: 2px;
      box-shadow: inset 0 1px #ffffff0f, inset 0 -2px #0003, 0 2px 6px #00000040;
      transition: background .12s ease, border-color .12s ease, transform 80ms ease;
      text-decoration: none;
      color: inherit;
    }

    .mc-list-item:hover {
      background: #46464699;
      border-color: #88bb5580;
      transform: translateY(-1px);
      box-shadow: inset 0 1px #ffffff14, inset 0 -2px #00000040, 0 4px 12px #00000059;
      color: #fff;
    }

    .mc-list-item:active {
      transform: translateY(1px);
      box-shadow: inset 0 2px #0000004d, 0 1px 2px #0003;
    }

    .mc-list-item .item-name {
      flex: 1;
      font-size: 1.05rem;
      font-weight: 700;
      color: var(--text);
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }

    .mc-list-item:hover .item-name { color: #fff; }

    .mc-list-item .item-tag {
      flex-shrink: 0;
      padding: 2px 8px;
      font-size: .85rem;
      font-weight: 600;
      text-transform: uppercase;
      color: var(--muted);
      border: 1px solid rgb(100 100 100 / .4);
      border-radius: 2px;
    }

    .mc-list-item .item-badge {
      flex-shrink: 0;
      padding: 4px 10px;
      font-size: .85rem;
      font-weight: 700;
      color: var(--accent);
      background: rgba(136, 187, 85, .12);
      border: 2px solid;
      border-color: rgb(136 187 85 / .4) rgb(80 120 50 / .4) rgb(80 120 50 / .4) rgb(136 187 85 / .4);
      border-radius: 2px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
    }

    /* Cards (detail panels) */
    .mc-card {
      background: rgba(30, 32, 38, .7);
      border: 2px solid rgb(80 88 104 / .3);
      border-radius: 4px;
      padding: 18px 20px;
      margin: 12px 0;
      box-shadow: inset 0 1px #ffffff0a, 0 4px 16px #0004;
    }

    .mc-card dl { }
    .mc-card dt {
      font-weight: 700;
      color: var(--accent);
      margin-top: 10px;
      text-transform: uppercase;
      font-size: .9rem;
      letter-spacing: .06em;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }
    .mc-card dt:first-child { margin-top: 0; }
    .mc-card dd {
      margin-left: 0;
      color: var(--stone);
      padding: 4px 0;
      font-size: 1.05rem;
    }

    /* Forms */
    .mc-form .form-group {
      margin: 14px 0;
    }

    .mc-form label {
      display: block;
      margin-bottom: 6px;
      font-weight: 700;
      font-size: .95rem;
      color: var(--stone);
      text-transform: uppercase;
      letter-spacing: .06em;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }

    .mc-form input[type="text"],
    .mc-form input[type="email"],
    .mc-form input[type="password"],
    .mc-form textarea {
      width: 100%;
      border: 2px solid #3e4452;
      border-radius: 2px;
      padding: 10px 14px;
      font-size: 1rem;
      font-family: inherit;
      color: var(--text);
      background: rgba(0, 0, 0, .5);
      outline: none;
      box-shadow: inset 0 2px rgba(0, 0, 0, .3), inset 0 -1px #ffffff0a;
      transition: border-color .16s ease, box-shadow .16s ease;
    }

    .mc-form input:focus,
    .mc-form textarea:focus {
      border-color: var(--accent);
      box-shadow: inset 0 2px rgba(0, 0, 0, .3), 0 0 0 2px rgba(136, 187, 85, .33);
    }

    /* Flash messages */
    .flash-notice {
      position: relative;
      z-index: 2;
      width: min(920px, 100%);
      background: rgba(136, 187, 85, .12);
      border: 2px solid rgba(136, 187, 85, .4);
      color: var(--accent);
      padding: 10px 16px;
      border-radius: 2px;
      margin-top: 8px;
      font-weight: 700;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }

    .flash-alert {
      position: relative;
      z-index: 2;
      width: min(920px, 100%);
      background: rgba(255, 125, 125, .1);
      border: 2px solid rgba(255, 125, 125, .35);
      color: var(--danger);
      padding: 10px 16px;
      border-radius: 2px;
      margin-top: 8px;
      font-weight: 700;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .4);
    }

    /* Actions row */
    .actions {
      margin-top: 20px;
      display: flex;
      gap: 8px;
      flex-wrap: wrap;
    }

    /* Messages list */
    .mc-message {
      padding: 10px 14px;
      background: rgba(30, 32, 38, .5);
      border: 2px solid rgb(60 64 76 / .4);
      border-radius: 2px;
      margin-bottom: 4px;
      box-shadow: inset 0 1px #ffffff06;
    }

    .mc-message .msg-sender {
      color: var(--accent);
      font-weight: 700;
      margin-right: 8px;
      text-shadow: 1px 1px 0 rgba(0, 0, 0, .5);
    }

    .mc-message .msg-content {
      color: var(--text);
    }

    .mc-message .msg-time {
      color: var(--muted);
      font-size: .85rem;
      margin-left: 8px;
    }

    /* Error page */
    .mc-error {
      text-align: center;
      padding: 40px 20px;
    }

    .mc-error .error-code {
      font-size: clamp(4rem, 10vw, 7rem);
      color: var(--accent);
      text-shadow: 3px 3px 0 rgba(0, 0, 0, .6);
      line-height: 1;
    }

    .mc-error .error-title {
      font-size: 1.4rem;
      color: var(--text);
      margin: 10px 0 6px;
      text-transform: uppercase;
      letter-spacing: .1em;
    }

    .mc-error .error-msg {
      color: var(--muted);
      margin-bottom: 24px;
    }

    /* Responsive */
    @media (max-width: 560px) {
      .mc-nav { flex-wrap: wrap; gap: 4px; padding: 10px 12px; }
      .mc-nav .nav-logo { width: 100%; margin-right: 0; margin-bottom: 4px; }
      .content-panel { padding: 18px 14px 22px; }
      .mc-list-item { padding: 10px 12px; gap: 8px; }
    }
  CSS

  class NavBar < Phlex::HTML
    def view_template
      a(href: "/", class: "nav-logo") { "⛏ Minechat" }
      a(href: "/users") { "用户" }
      a(href: "/rooms") { "房间" }
    end
  end

  private

  def flash_messages
    if helpers.flash[:notice]
      div(class: "flash-notice") { helpers.flash[:notice] }
    end
    if helpers.flash[:alert]
      div(class: "flash-alert") { helpers.flash[:alert] }
    end
  end
end
