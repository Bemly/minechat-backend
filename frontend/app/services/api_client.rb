# 后端 API 客户端服务
# 负责与 minechat backend API 通信
class ApiClient
  include HTTParty
  base_uri Rails.application.config.x.api_url
  format :json
  headers "Accept" => "application/vnd.api+json"
  headers "Content-Type" => "application/json"

  # ===== Users =====

  def self.users
    get("/users").parsed_response
  end

  def self.user(id)
    get("/users/#{id}").parsed_response
  end

  def self.create_user(params)
    post("/users", body: { user: params }.to_json).parsed_response
  end

  def self.update_user(id, params)
    patch("/users/#{id}", body: { user: params }.to_json).parsed_response
  end

  def self.destroy_user(id)
    delete("/users/#{id}").parsed_response
  end

  # ===== Rooms =====

  def self.rooms
    get("/rooms").parsed_response
  end

  def self.room(id)
    get("/rooms/#{id}").parsed_response
  end

  def self.create_room(params)
    post("/rooms", body: { room: params }.to_json).parsed_response
  end

  def self.update_room(id, params)
    patch("/rooms/#{id}", body: { room: params }.to_json).parsed_response
  end

  def self.destroy_room(id)
    delete("/rooms/#{id}").parsed_response
  end

  # ===== Messages =====

  def self.room_messages(room_id)
    get("/rooms/#{room_id}/messages").parsed_response
  end

  def self.create_message(room_id, params)
    post("/rooms/#{room_id}/messages", body: { message: params }.to_json).parsed_response
  end

  def self.message(id)
    get("/messages/#{id}").parsed_response
  end

  def self.update_message(id, params)
    patch("/messages/#{id}", body: { message: params }.to_json).parsed_response
  end

  def self.destroy_message(id)
    delete("/messages/#{id}").parsed_response
  end

  # ===== Members =====

  def self.room_members(room_id)
    get("/rooms/#{room_id}/members").parsed_response
  end

  def self.create_member(room_id, params)
    post("/rooms/#{room_id}/members", body: { member: params }.to_json).parsed_response
  end

  def self.destroy_member(room_id, member_id)
    delete("/rooms/#{room_id}/members/#{member_id}").parsed_response
  end
end
