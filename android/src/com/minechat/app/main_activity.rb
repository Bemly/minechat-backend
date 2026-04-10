# frozen_string_literal: true

require "ruboto"
require "ruboto/activity"
require "httparty"
require "json"

# ===== API 客户端 =====
class MinechatAPI
  include HTTParty
  default_timeout 10

  def self.set_base_url(url)
    @base_url = url
  end

  def self.base_url
    @base_url || "http://10.0.2.2:3000"
  end

  def self.login(username, password)
    response = HTTParty.get("#{base_url}/users")
    return nil unless response.code == 200

    users = JSON.parse(response.body)["data"] || []
    users.find do |u|
      u.dig("attributes", "username") == username &&
        u.dig("attributes", "passwd") == password
    end
  rescue StandardError
    nil
  end

  def self.rooms(base_url = nil)
    url = base_url || "http://10.0.2.2:3000"
    response = HTTParty.get("#{url}/rooms")
    return [] unless response.code == 200
    JSON.parse(response.body)["data"] || []
  rescue StandardError
    []
  end

  def self.room_messages(room_id, base_url = nil)
    url = base_url || "http://10.0.2.2:3000"
    response = HTTParty.get("#{url}/rooms/#{room_id}/messages")
    return [] unless response.code == 200
    JSON.parse(response.body)["data"] || []
  rescue StandardError
    []
  end

  def self.send_message(room_id, sender_id, content, base_url = nil)
    url = base_url || "http://10.0.2.2:3000"
    HTTParty.post("#{url}/rooms/#{room_id}/messages",
                  body: { message: { sender_id: sender_id, content: content } }.to_json,
                  headers: { "Content-Type" => "application/json" })
  rescue StandardError
    nil
  end
end

# ===== 登录 Activity =====
class LoginActivity
  include Ruboto::Activity

  def onCreate(bundle)
    super
    set_content_view create_login_layout
  end

  private

  def create_login_layout
    @linear_layout = Android::Widget::LinearLayout.new(self)
    @linear_layout.orientation = Android::Widget::LinearLayout::VERTICAL
    @linear_layout.set_padding(16, 16, 16, 16)

    # 标题
    @title = Android::Widget::TextView.new(self)
    @title.text = "Minechat"
    @title.text_size = 24.0
    @title.gravity = Android::View::Gravity::CENTER
    @linear_layout.add_view(@title)

    # 用户名输入框
    @username_label = Android::Widget::TextView.new(self)
    @username_label.text = "用户名:"
    @linear_layout.add_view(@username_label)

    @username_input = Android::Widget::EditText.new(self)
    @username_input.hint = "请输入用户名"
    @linear_layout.add_view(@username_input)

    # 密码输入框
    @password_label = Android::Widget::TextView.new(self)
    @password_label.text = "密码:"
    @linear_layout.add_view(@password_label)

    @password_input = Android::Widget::EditText.new(self)
    @password_input.hint = "请输入密码"
    @password_input.input_type = Android::Text::InputType::TYPE_CLASS_TEXT |
                                  Android::Text::InputType::TYPE_TEXT_VARIATION_PASSWORD
    @linear_layout.add_view(@password_input)

    # 登录按钮
    @login_button = Android::Widget::Button.new(self)
    @login_button.text = "登录"
    @login_button.on_click do
      perform_login
    end
    @linear_layout.add_view(@login_button)

    # API 地址配置
    @api_label = Android::Widget::TextView.new(self)
    @api_label.text = "API 地址:"
    @linear_layout.add_view(@api_label)

    @api_input = Android::Widget::EditText.new(self)
    @api_input.hint = "http://10.0.2.2:3000"
    @api_input.text = "http://10.0.2.2:3000"
    @linear_layout.add_view(@api_input)

    @linear_layout
  end

  def perform_login
    username = @username_input.text.to_s
    password = @password_input.text.to_s
    api_url = @api_input.text.to_s

    MinechatAPI.set_base_url(api_url)
    user = MinechatAPI.login(username, password)

    if user
      intent = Android::Content::Intent.new(self, MainActivity)
      intent.put_extra("user", user.to_json)
      intent.put_extra("api_url", api_url)
      start_activity(intent)
      finish
    else
      Android::Widget::Toast.make_text(self, "登录失败，请检查用户名和密码",
                                        Android::Widget::Toast::LENGTH_LONG).show
    end
  rescue StandardError => e
    Android::Widget::Toast.make_text(self, "网络错误: #{e.message}",
                                      Android::Widget::Toast::LENGTH_LONG).show
  end
end

# ===== 主 Activity (房间列表 + 聊天) =====
class MainActivity
  include Ruboto::Activity

  def onCreate(bundle)
    super
    @user = JSON.parse(intent.get_string_extra("user"))
    @api_url = intent.get_string_extra("api_url")
    set_content_view create_main_layout
    load_rooms
  end

  private

  def create_main_layout
    @linear_layout = Android::Widget::LinearLayout.new(self)
    @linear_layout.orientation = Android::Widget::LinearLayout::VERTICAL

    # 顶部标题栏
    @header = Android::Widget::TextView.new(self)
    @header.text = "Minechat - #{@user.dig("attributes", "nickname")}"
    @header.text_size = 20.0
    @header.gravity = Android::View::Gravity::CENTER
    @linear_layout.add_view(@header)

    # 房间列表
    @room_list = Android::Widget::ListView.new(self)
    @linear_layout.add_view(@room_list)

    @linear_layout
  end

  def load_rooms
    @rooms = MinechatAPI.rooms(@api_url)
    room_names = @rooms.map { |r| r.dig("attributes", "name") || "未命名" }

    adapter = Android::Widget::ArrayAdapter.new(self,
                                                 Android::R::Layout::Simple_list_item_1,
                                                 room_names.to_java(:string))
    @room_list.adapter = adapter

    @room_list.on_item_click do |_parent, _view, position, _id|
      open_room(@rooms[position])
    end
  end

  def open_room(room)
    intent = Android::Content::Intent.new(self, ChatActivity)
    intent.put_extra("room", room.to_json)
    intent.put_extra("user", @user.to_json)
    intent.put_extra("api_url", @api_url)
    start_activity(intent)
  end
end

# ===== 聊天 Activity =====
class ChatActivity
  include Ruboto::Activity

  def onCreate(bundle)
    super
    @room = JSON.parse(intent.get_string_extra("room"))
    @user = JSON.parse(intent.get_string_extra("user"))
    @api_url = intent.get_string_extra("api_url")
    set_content_view create_chat_layout
    load_messages
  end

  private

  def create_chat_layout
    @linear_layout = Android::Widget::LinearLayout.new(self)
    @linear_layout.orientation = Android::Widget::LinearLayout::VERTICAL

    # 房间标题
    @title = Android::Widget::TextView.new(self)
    @title.text = @room.dig("attributes", "name")
    @title.text_size = 18.0
    @title.gravity = Android::View::Gravity::CENTER
    @linear_layout.add_view(@title)

    # 消息列表
    @message_list = Android::Widget::ListView.new(self)
    @linear_layout.add_view(@message_list)

    # 输入区域
    @input_layout = Android::Widget::LinearLayout.new(self)
    @input_layout.orientation = Android::Widget::LinearLayout::HORIZONTAL

    @message_input = Android::Widget::EditText.new(self)
    @message_input.hint = "输入消息..."
    @message_input.layout_params = Android::Widget::LinearLayout::LayoutParams.new(
      0, Android::Widget::LinearLayout::LayoutParams::WRAP_CONTENT, 1.0
    )
    @input_layout.add_view(@message_input)

    @send_button = Android::Widget::Button.new(self)
    @send_button.text = "发送"
    @send_button.on_click { send_message }
    @input_layout.add_view(@send_button)

    @linear_layout.add_view(@input_layout)

    @linear_layout
  end

  def load_messages
    @messages = MinechatAPI.room_messages(@room["id"], @api_url)
    message_texts = @messages.map do |msg|
      sender = msg.dig("attributes", "sender_id") || "?"
      content = msg.dig("attributes", "content") || ""
      "#{sender}: #{content}"
    end

    @adapter = Android::Widget::ArrayAdapter.new(self,
                                                  Android::R::Layout::Simple_list_item_1,
                                                  message_texts.to_java(:string))
    @message_list.adapter = @adapter
  end

  def send_message
    content = @message_input.text.to_s.strip
    return if content.empty?

    result = MinechatAPI.send_message(@room["id"], @user["id"], content, @api_url)
    if result
      @message_input.text = ""
      load_messages
    else
      Android::Widget::Toast.make_text(self, "发送失败",
                                        Android::Widget::Toast::LENGTH_SHORT).show
    end
  end
end
