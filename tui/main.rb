#!/usr/bin/env ruby
# frozen_string_literal: true

# Minechat TUI 客户端 - 基于 cli-ui
#
# 启动方式: bundle exec ruby main.rb
#
# 环境变量:
#   MINECHAT_API_URL - 后端 API 地址 (默认 http://localhost:3000)

require "cli/ui"
require "httparty"

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

# ===== TUI 应用 =====
class MinechatTUI
  def initialize
    @current_user = nil
    @current_room = nil
  end

  def run
    CLI::UI::StdoutRouter.enable
    login_screen
  end

  private

  def login_screen
    CLI::UI::Frame.open("Minechat 登录", color: :cyan) do
      puts

      username = CLI::UI.ask("用户名: ")
      password = CLI::UI.ask("密  码: ", echo_char: "*")

      @current_user = MinechatAPI.login(username, password)

      if @current_user
        CLI::UI::Frame.open("登录成功，欢迎 #{@current_user.dig("attributes", "nickname") || username}!", color: :green)
        main_screen
      else
        CLI::UI::Frame.open("登录失败，请重试", color: :red)
        login_screen
      end
    end
  end

  def main_screen
    loop do
      CLI::UI::Frame.open("主菜单", color: :blue) do
        choice = CLI::UI.prompt(
          "选择操作",
          options: [
            ["查看房间列表", :rooms],
            ["发送消息", :send],
            ["退出", :quit]
          ]
        )

        case choice
        when :rooms
          show_rooms
        when :send
          send_message_flow
        when :quit
          CLI::UI::Frame.open("再见!", color: :yellow)
          break
        end
      end
    end
  end

  def show_rooms
    rooms = MinechatAPI.rooms

    if rooms.empty?
      CLI::UI::Frame.open("暂无房间", color: :yellow)
      return
    end

    CLI::UI::Frame.open("房间列表", color: :blue) do
      rooms.each_with_index do |room, i|
        name = room.dig("attributes", "name") || "未命名"
        type = room.dig("attributes", "room_type") || "未分类"
        CLI::UI::Widget.draw(CLI::UI::Widgets::Progress.new(0))
        puts "#{i + 1}. #{name} (#{type}) [ID: #{room["id"]}]"
      end

      puts
      room_idx = CLI::UI.ask("输入房间编号查看消息 (0 返回): ").to_i
      return if room_idx.zero?

      room = rooms[room_idx - 1]
      return unless room

      show_room_messages(room["id"])
    end
  end

  def show_room_messages(room_id)
    messages = MinechatAPI.room_messages(room_id)

    CLI::UI::Frame.open("消息", color: :cyan) do
      if messages.empty?
        puts "暂无消息"
      else
        messages.each do |msg|
          sender = msg.dig("attributes", "sender_id") || "?"
          content = msg.dig("attributes", "content") || ""
          time = msg.dig("attributes", "timestamp") || ""
          puts "[#{time}] #{sender}: #{content}"
        end
      end
    end

    # 发送新消息
    loop do
      input = CLI::UI.ask("输入消息 (空行返回, 'quit' 退出): ")
      break if input.strip.empty?
      break if input.strip.downcase == "quit"
      next if input.strip.empty?

      result = MinechatAPI.send_message(room_id, @current_user["id"], input.strip)
      if result
        CLI::UI::Frame.open("发送成功", color: :green)
        show_room_messages(room_id)
        break
      else
        CLI::UI::Frame.open("发送失败", color: :red)
      end
    end
  end

  def send_message_flow
    rooms = MinechatAPI.rooms
    return if rooms.empty?

    CLI::UI::Frame.open("选择房间", color: :blue) do
      rooms.each_with_index do |room, i|
        name = room.dig("attributes", "name") || "未命名"
        puts "#{i + 1}. #{name}"
      end

      puts
      room_idx = CLI::UI.ask("输入房间编号: ").to_i
      return if room_idx.zero? || room_idx > rooms.size

      room = rooms[room_idx - 1]
      content = CLI::UI.ask("输入消息: ")
      return if content.strip.empty?

      result = MinechatAPI.send_message(room["id"], @current_user["id"], content.strip)
      if result
        CLI::UI::Frame.open("发送成功", color: :green)
      else
        CLI::UI::Frame.open("发送失败", color: :red)
      end
    end
  end
end

# 启动应用
MinechatTUI.new.run
