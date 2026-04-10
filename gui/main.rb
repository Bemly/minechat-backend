#!/usr/bin/env ruby
# frozen_string_literal: true

# Minechat GUI 客户端 - 基于 Shoes 4
#
# 启动方式: bundle exec ruby main.rb
#
# 注意: Shoes 4 仍在开发中，某些功能可能不稳定。
# 如果遇到兼容性问题，请参考 https://github.com/shoes/shoes4

require "httparty"

# ===== API 客户端 =====
class MinechatAPI
  include HTTParty
  base_uri ENV.fetch("MINECHAT_API_URL", "http://localhost:3000")
  headers "Accept" => "application/json"
  headers "Content-Type" => "application/json"

  def self.login(username, password)
    # 注意: 当前后端 API 没有独立的登录端点
    # 这里通过查询用户并验证密码的方式实现（仅供演示）
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

# ===== Shoes 4 应用 =====
# 注意: 由于 Shoes 4 的 API 可能在不同版本间变化，
# 以下代码是一个基础框架，可能需要根据实际安装的 Shoes 4 版本进行调整。

Shoes.app(title: "Minechat", width: 800, height: 600) do
  # 全局状态
  @current_user = nil
  @current_room = nil

  # ===== 登录界面 =====
  stack do
    @login_stack = stack do
      title "Minechat 登录", align: "center"

      flow do
        para "用户名: "
        @username_input = edit_line width: 200
      end

      flow do
        para "密  码: "
        @password_input = edit_line width: 200, secret: true
      end

      flow do
        @login_button = button "登录" do
          username = @username_input.text
          password = @password_input.text

          user = MinechatAPI.login(username, password)
          if user
            @current_user = user
            @login_stack.hide
            @main_stack.show
            load_rooms
          else
            alert "登录失败，请检查用户名和密码"
          end
        end
      end
    end
  end

  # ===== 主界面 =====
  stack do
    @main_stack = stack do
      @main_stack.hide # 初始隐藏，登录后显示

      # 顶部导航
      flow do
        @user_label = para "用户: "
        @logout_button = button "退出" do
          @main_stack.hide
          @login_stack.show
          @current_user = nil
          @current_room = nil
        end
      end

      # 房间列表和消息区域
      flow do
        # 左侧：房间列表
        @room_stack = stack(width: 200) do
          title "房间列表"
          @room_list_box = list_box items: [], width: 180 do |list|
            if list.selected
              @current_room = list.selected
              load_messages
            end
          end
        end

        # 右侧：消息区域
        stack do
          title "消息"
          @message_area = stack(width: 500, height: 400) do
            para "选择一个房间开始聊天..."
          end

          # 输入区域
          flow do
            @message_input = edit_line width: 400
            @send_button = button "发送" do
              send_message
            end
          end
        end
      end
    end
  end

  # ===== 辅助方法 =====
  def load_rooms
    rooms = MinechatAPI.rooms
    room_names = rooms.map { |r| r.dig("attributes", "name") || "未命名" }
    @room_list_box.items = room_names.zip(rooms.map { |r| r["id"] })
  end

  def load_messages
    return unless @current_room

    @message_area.clear
    messages = MinechatAPI.room_messages(@current_room)

    if messages.empty?
      @message_area.append do
        para "暂无消息"
      end
    else
      messages.each do |msg|
        @message_area.append do
          sender = msg.dig("attributes", "sender_id") || "未知"
          content = msg.dig("attributes", "content") || ""
          timestamp = msg.dig("attributes", "timestamp") || ""
          para "#{sender}: #{content}  #{timestamp}"
        end
      end
    end
  end

  def send_message
    return unless @current_user && @current_room

    content = @message_input.text.strip
    return if content.empty?

    sender_id = @current_user["id"]
    result = MinechatAPI.send_message(@current_room, sender_id, content)

    if result
      @message_input.text = ""
      load_messages
    else
      alert "发送失败"
    end
  end
end
