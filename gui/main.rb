#!/usr/bin/env ruby
# frozen_string_literal: true

# Minechat GUI 客户端 - 基于 Gosu
#
# 启动方式: bundle exec ruby main.rb
#
# 环境变量:
#   MINECHAT_API_URL - 后端 API 地址 (默认 http://localhost:3000)

require "gosu"
require "httparty"
require "json"

# ===== API 客户端 =====
class MinechatAPI
  include HTTParty
  base_uri ENV.fetch("MINECHAT_API_URL", "http://localhost:3000")
  headers "Accept" => "application/json"
  headers "Content-Type" => "application/json"

  def self.login(username, password)
    response = get("/users")
    return nil unless response.code == 200

    users = response.parsed_response["data"] || []
    users.find do |u|
      u.dig("attributes", "username") == username &&
        u.dig("attributes", "passwd") == password
    end
  rescue StandardError
    nil
  end

  def self.rooms
    response = get("/rooms")
    return [] unless response.code == 200
    response.parsed_response["data"] || []
  rescue StandardError
    []
  end

  def self.room_messages(room_id)
    response = get("/rooms/#{room_id}/messages")
    return [] unless response.code == 200
    response.parsed_response["data"] || []
  rescue StandardError
    []
  end

  def self.send_message(room_id, sender_id, content)
    post("/rooms/#{room_id}/messages",
         body: { message: { sender_id: sender_id, content: content } }.to_json)
  rescue StandardError
    nil
  end

  def self.users
    response = get("/users")
    return [] unless response.code == 200
    response.parsed_response["data"] || []
  rescue StandardError
    []
  end
end

# ===== Gosu 窗口 =====
class MinechatWindow < Gosu::Window
  WIDTH = 900
  HEIGHT = 650
  FONT_SIZE = 16
  TITLE_SIZE = 22
  BUTTON_HEIGHT = 40
  INPUT_HEIGHT = 35
  LINE_HEIGHT = 26

  def initialize
    super(WIDTH, HEIGHT)
    self.caption = "Minechat"
    @font = Gosu::Font.new(FONT_SIZE)
    @title_font = Gosu::Font.new(TITLE_SIZE, bold: true)

    # 颜色
    @bg_color = Gosu::Color.argb(255, 30, 30, 40)
    @text_color = Gosu::Color.argb(255, 230, 230, 230)
    @accent_color = Gosu::Color.argb(255, 80, 140, 255)
    @input_bg = Gosu::Color.argb(255, 50, 50, 65)
    @button_bg = Gosu::Color.argb(255, 60, 120, 220)
    @button_hover = Gosu::Color.argb(255, 80, 150, 255)
    @error_color = Gosu::Color.argb(255, 255, 80, 80)

    @current_user = nil
    @current_room = nil
    @screen = :login

    @username = ""
    @password = ""
    @message_input = ""
    @active_input = :username

    @scroll_offset = 0
    @hovered_button = nil
  end

  def update
    if @screen == :chat && @current_room
      @messages ||= []
      new_messages = MinechatAPI.room_messages(@current_room["id"])
      if new_messages.length != @messages.length
        @messages = new_messages
        @scroll_offset = @messages.length * LINE_HEIGHT
      end
    end
  end

  def draw
    # 背景
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, @bg_color)

    case @screen
    when :login
      draw_login_screen
    when :rooms
      draw_rooms_screen
    when :chat
      draw_chat_screen
    end
  end

  # 辅助方法: Gosu draw_text 的 y 是基线，加偏移让文字居中
  def draw_text(font, text, x, y, color)
    font.draw_text(text, x, y + FONT_SIZE, 0, 1.0, 1.0, color)
  end

  def draw_login_screen
    draw_text(@title_font, "Minechat", WIDTH / 2 - 80, 80, @accent_color)

    # 用户名
    draw_text(@font, "用户名:", 200, 180, @text_color)
    Gosu.draw_rect(200, 210, 500, INPUT_HEIGHT, @input_bg)
    draw_text(@font, @username + (@active_input == :username ? "|" : ""), 210, 214, @text_color)

    # 密码
    draw_text(@font, "密  码:", 200, 280, @text_color)
    Gosu.draw_rect(200, 310, 500, INPUT_HEIGHT, @input_bg)
    draw_text(@font, "*" * @password.length + (@active_input == :password ? "|" : ""), 210, 314, @text_color)

    # API 地址
    draw_text(@font, "API:", 200, 380, @text_color)
    Gosu.draw_rect(250, 375, 450, INPUT_HEIGHT, @input_bg)
    draw_text(@font, (@api_url_text || "") + (@active_input == :api ? "|" : ""), 260, 379, @text_color)

    # 登录按钮
    btn_color = @hovered_button == :login ? @button_hover : @button_bg
    Gosu.draw_rect(350, 440, 200, BUTTON_HEIGHT, btn_color)
    draw_text(@font, "登录", 420, 450, Gosu::Color::WHITE)

    draw_text(@font, @error_msg.to_s, 250, 520, @error_color) if @error_msg
  end

  def draw_rooms_screen
    draw_text(@title_font, "房间列表", 350, 30, @accent_color)
    draw_text(@font, "欢迎, #{@current_user.dig("attributes", "nickname")}", 350, 60, @text_color)

    rooms = @rooms || []
    rooms.each_with_index do |room, i|
      name = room.dig("attributes", "name") || "未命名"
      type = room.dig("attributes", "room_type") || ""
      y = 120 + i * 60
      btn_color = @hovered_button == :"room_#{i}" ? @button_hover : @button_bg
      Gosu.draw_rect(200, y, 500, 50, btn_color)
      draw_text(@font, "#{name}  (#{type})", 220, y + 12, Gosu::Color::WHITE)
    end

    if rooms.empty?
      draw_text(@font, "暂无房间，请确保后端服务已启动", 250, 200, @text_color)
    end

    exit_color = @hovered_button == :exit ? Gosu::Color.argb(255, 200, 60, 60) : Gosu::Color.argb(255, 150, 50, 50)
    Gosu.draw_rect(700, 580, 150, BUTTON_HEIGHT, exit_color)
    draw_text(@font, "退出", 745, 592, Gosu::Color::WHITE)
  end

  def draw_chat_screen
    room_name = @current_room.dig("attributes", "name") || "聊天"

    # 顶部栏
    Gosu.draw_rect(0, 0, WIDTH, 50, @input_bg)
    draw_text(@title_font, "< 返回", 20, 10, @accent_color)
    draw_text(@title_font, room_name, WIDTH / 2 - 60, 10, @accent_color)

    # 消息区域
    Gosu.draw_rect(20, 60, WIDTH - 40, HEIGHT - 140, @input_bg)

    messages = @messages || []
    visible_start = [@scroll_offset / LINE_HEIGHT - ((HEIGHT - 220) / LINE_HEIGHT).to_i, 0].max
    messages[visible_start..].each_with_index do |msg, i|
      y = 80 + i * LINE_HEIGHT
      sender = msg.dig("attributes", "sender_id") || "?"
      content = msg.dig("attributes", "content") || ""
      draw_text(@font, "#{sender}: #{content}", 30, y, @text_color)
    end

    # 输入区域
    Gosu.draw_rect(20, HEIGHT - 70, WIDTH - 220, INPUT_HEIGHT, @input_bg)
    draw_text(@font, @message_input + "|", 30, HEIGHT - 65, @text_color)

    # 发送按钮
    send_color = @hovered_button == :send ? @button_hover : @button_bg
    Gosu.draw_rect(WIDTH - 180, HEIGHT - 70, 160, INPUT_HEIGHT, send_color)
    draw_text(@font, "发送", WIDTH - 140, HEIGHT - 62, Gosu::Color::WHITE)
  end

  def button_down(id)
    case id
    when Gosu::KB_ESCAPE
      if @screen == :chat
        @screen = :rooms
        @messages = nil
      elsif @screen == :rooms
        @screen = :login
      end
    when Gosu::KB_RETURN
      handle_enter
    when Gosu::KB_BACKSPACE
      case @active_input
      when :username then @username.chop!
      when :password then @password.chop!
      when :message  then @message_input.chop!
      when :api      then @api_url_text = (@api_url_text || "")[0...-1]
      end
    end
  end

  def text_input=(text)
    case @active_input
    when :username then @username += text
    when :password then @password += text
    when :message  then @message_input += text
    when :api
      @api_url_text ||= ""
      @api_url_text += text
    end
  end

  def handle_enter
    case @screen
    when :login then perform_login
    when :chat  then send_message
    end
  end

  def perform_login
    @api_url_text ||= "http://localhost:3000"
    MinechatAPI.base_uri = @api_url_text

    user = MinechatAPI.login(@username, @password)
    if user
      @current_user = user
      @rooms = MinechatAPI.rooms
      @screen = :rooms
      @error_msg = nil
    else
      @error_msg = "登录失败，请检查用户名和密码"
    end
  rescue StandardError => e
    @error_msg = "连接失败: #{e.message}"
  end

  def send_message
    return unless @current_room && @message_input.strip != ""

    result = MinechatAPI.send_message(@current_room["id"], @current_user["id"], @message_input.strip)
    if result
      @message_input = ""
      @messages = MinechatAPI.room_messages(@current_room["id"])
    end
  rescue StandardError
  end

  def mouse_move(x, y)
    @hovered_button = nil
    case @screen
    when :login
      @hovered_button = :login if x >= 350 && x <= 550 && y >= 440 && y <= 480
    when :rooms
      @rooms&.each_with_index do |_, i|
        btn_y = 120 + i * 60
        @hovered_button = :"room_#{i}" if x >= 200 && x <= 700 && y >= btn_y && y <= btn_y + 50
      end
      @hovered_button = :exit if x >= 700 && x <= 850 && y >= 580 && y <= 620
    when :chat
      @hovered_button = :send if x >= WIDTH - 180 && x <= WIDTH - 20 && y >= HEIGHT - 70 && y <= HEIGHT - 35
    end
  end

  def mouse_button_down(button)
    x = mouse_x
    y = mouse_y
    case @screen
    when :login
      if x >= 350 && x <= 550 && y >= 440 && y <= 480
        perform_login
      elsif y >= 210 && y <= 245
        @active_input = :username
      elsif y >= 310 && y <= 345
        @active_input = :password
      elsif y >= 375 && y <= 410
        @active_input = :api
      end
    when :rooms
      @rooms&.each_with_index do |room, i|
        btn_y = 120 + i * 60
        if x >= 200 && x <= 700 && y >= btn_y && y <= btn_y + 50
          @current_room = room
          @messages = MinechatAPI.room_messages(room["id"])
          @screen = :chat
          @scroll_offset = @messages.length * LINE_HEIGHT
          return
        end
      end
      close if x >= 700 && x <= 850 && y >= 580 && y <= 620
    when :chat
      if x >= 20 && x <= 120 && y >= 10 && y <= 40
        @screen = :rooms
        @messages = nil
        return
      end
      send_message if x >= WIDTH - 180 && x <= WIDTH - 20 && y >= HEIGHT - 70 && y <= HEIGHT - 35
    end
  end
end

MinechatWindow.new.show
