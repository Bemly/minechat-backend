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
    super(width: WIDTH, height: HEIGHT, fullscreen: false)
    self.caption = "Minechat"
    @font = Gosu::Font.new(FONT_SIZE, name: "Monaco")
    @title_font = Gosu::Font.new(TITLE_SIZE, name: "Monaco", bold: true)

    # 颜色
    @bg_color = Gosu::Color.argb(255, 30, 30, 40)
    @text_color = Gosu::Color.argb(255, 230, 230, 230)
    @accent_color = Gosu::Color.argb(255, 80, 140, 255)
    @input_bg = Gosu::Color.argb(255, 50, 50, 65)
    @button_bg = Gosu::Color.argb(255, 60, 120, 220)
    @button_hover = Gosu::Color.argb(255, 80, 150, 255)
    @error_color = Gosu::Color.argb(255, 255, 80, 80)
    @success_color = Gosu::Color.argb(255, 80, 220, 120)

    @current_user = nil
    @current_room = nil
    @screen = :login

    # 输入框
    @username = ""
    @password = ""
    @message_input = ""
    @active_input = :username

    # 消息滚动
    @scroll_offset = 0

    # 按钮状态
    @hovered_button = nil
  end

  def update
    # 定期刷新消息
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
    Gosu.draw_rect(0, 0, WIDTH, HEIGHT, @bg_color, z: 0)

    case @screen
    when :login
      draw_login_screen
    when :rooms
      draw_rooms_screen
    when :chat
      draw_chat_screen
    end
  end

  # ===== 登录界面 =====
  def draw_login_screen
    @title_font.draw_text("Minechat", WIDTH / 2 - 80, 80, z: 10, color: @accent_color)

    # 用户名
    @font.draw_text("用户名:", 200, 180, z: 10, color: @text_color)
    Gosu.draw_rect(200, 210, 500, INPUT_HEIGHT, @input_bg, z: 5)
    @font.draw_text(@username + (@active_input == :username ? "|" : ""), 210, 214, z: 10, color: @text_color)

    # 密码
    @font.draw_text("密  码:", 200, 280, z: 10, color: @text_color)
    Gosu.draw_rect(200, 310, 500, INPUT_HEIGHT, @input_bg, z: 5)
    @font.draw_text("*" * @password.length + (@active_input == :password ? "|" : ""), 210, 314, z: 10, color: @text_color)

    # API 地址
    @font.draw_text("API:", 200, 380, z: 10, color: @text_color)
    Gosu.draw_rect(250, 375, 450, INPUT_HEIGHT, @input_bg, z: 5)
    @font.draw_text(@api_url_text.to_s + (@active_input == :api ? "|" : ""), 260, 379, z: 10, size: 12, color: @text_color)

    # 登录按钮
    btn_color = @hovered_button == :login ? @button_hover : @button_bg
    Gosu.draw_rect(350, 440, 200, BUTTON_HEIGHT, btn_color, z: 5)
    @font.draw_text("登录", 420, 450, z: 10, color: Gosu::Color::WHITE)

    # 错误提示
    @font.draw_text(@error_msg.to_s, 250, 520, z: 10, color: @error_color) if @error_msg
  end

  # ===== 房间列表界面 =====
  def draw_rooms_screen
    @title_font.draw_text("房间列表", 350, 30, z: 10, color: @accent_color)
    @font.draw_text("欢迎, #{@current_user.dig("attributes", "nickname")}", 350, 60, z: 10, color: @text_color)

    rooms = @rooms || []
    rooms.each_with_index do |room, i|
      name = room.dig("attributes", "name") || "未命名"
      type = room.dig("attributes", "room_type") || ""
      y = 120 + i * 60
      btn_color = @hovered_button == :"room_#{i}" ? @button_hover : @button_bg
      Gosu.draw_rect(200, y, 500, 50, btn_color, z: 5)
      @font.draw_text("#{name}  (#{type})", 220, y + 12, z: 10, color: Gosu::Color::WHITE)
    end

    if rooms.empty?
      @font.draw_text("暂无房间，请确保后端服务已启动", 250, 200, z: 10, color: @text_color)
    end

    # 退出按钮
    exit_color = @hovered_button == :exit ? Gosu::Color.argb(255, 200, 60, 60) : Gosu::Color.argb(255, 150, 50, 50)
    Gosu.draw_rect(700, 580, 150, BUTTON_HEIGHT, exit_color, z: 5)
    @font.draw_text("退出", 745, 592, z: 10, color: Gosu::Color::WHITE)
  end

  # ===== 聊天界面 =====
  def draw_chat_screen
    room_name = @current_room.dig("attributes", "name") || "聊天"

    # 顶部栏
    Gosu.draw_rect(0, 0, WIDTH, 50, @input_bg, z: 5)
    @title_font.draw_text("< 返回", 20, 10, z: 10, color: @accent_color)
    @title_font.draw_text(room_name, WIDTH / 2 - 60, 10, z: 10, color: @accent_color)

    # 消息区域
    Gosu.draw_rect(20, 60, WIDTH - 40, HEIGHT - 140, @input_bg, z: 2)

    messages = @messages || []
    visible_start = [@scroll_offset / LINE_HEIGHT - ((HEIGHT - 220) / LINE_HEIGHT).to_i, 0].max
    messages[visible_start..].each_with_index do |msg, i|
      y = 80 + i * LINE_HEIGHT
      sender = msg.dig("attributes", "sender_id") || "?"
      content = msg.dig("attributes", "content") || ""
      @font.draw_text("#{sender}: #{content}", 30, y, z: 10, color: @text_color)
    end

    # 输入区域
    Gosu.draw_rect(20, HEIGHT - 70, WIDTH - 220, INPUT_HEIGHT, @input_bg, z: 5)
    @font.draw_text(@message_input + "|", 30, HEIGHT - 65, z: 10, color: @text_color)

    # 发送按钮
    send_color = @hovered_button == :send ? @button_hover : @button_bg
    Gosu.draw_rect(WIDTH - 180, HEIGHT - 70, 160, INPUT_HEIGHT, send_color, z: 5)
    @font.draw_text("发送", WIDTH - 140, HEIGHT - 62, z: 10, color: Gosu::Color::WHITE)
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
      when :username
        @username.chop!
      when :password
        @password.chop!
      when :message
        @message_input.chop!
      when :api
        @api_url_text = @api_url_text.to_s[0...-1] if @api_url_text
      end
    end
  end

  def button_up(id)
    # handled below
  end

  def text_input=(text)
    case @active_input
    when :username
      @username += text
    when :password
      @password += text
    when :message
      @message_input += text
    when :api
      @api_url_text ||= ""
      @api_url_text += text
    end
  end

  def handle_enter
    case @screen
    when :login
      perform_login
    when :chat
      send_message
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
    # ignore
  end

  def mouse_move(x, y)
    @hovered_button = nil

    case @screen
    when :login
      @hovered_button = :login if x >= 350 && x <= 550 && y >= 440 && y <= 480
    when :rooms
      rooms = @rooms || []
      rooms.each_with_index do |_, i|
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
      # 登录按钮
      if x >= 350 && x <= 550 && y >= 440 && y <= 480
        perform_login
      # 输入框点击
      elsif y >= 210 && y <= 245
        @active_input = :username
      elsif y >= 310 && y <= 345
        @active_input = :password
      elsif y >= 375 && y <= 410
        @active_input = :api
      end

    when :rooms
      rooms = @rooms || []
      rooms.each_with_index do |room, i|
        btn_y = 120 + i * 60
        if x >= 200 && x <= 700 && y >= btn_y && y <= btn_y + 50
          @current_room = room
          @messages = MinechatAPI.room_messages(room["id"])
          @screen = :chat
          @scroll_offset = @messages.length * LINE_HEIGHT
          return
        end
      end
      # 退出
      if x >= 700 && x <= 850 && y >= 580 && y <= 620
        close
      end

    when :chat
      # 返回按钮
      if x >= 20 && x <= 120 && y >= 10 && y <= 40
        @screen = :rooms
        @messages = nil
        return
      end
      # 发送按钮
      if x >= WIDTH - 180 && x <= WIDTH - 20 && y >= HEIGHT - 70 && y <= HEIGHT - 35
        send_message
      end
    end
  end
end

# 启动应用
MinechatWindow.new.show
