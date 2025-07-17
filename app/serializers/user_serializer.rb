class UserSerializer
  include JSONAPI::Serializer

  # 1. 定义资源类型和ID
  # 这是 JSON:API 规范的要求，通常是模型名称的小写复数形式
  set_type :user    # 这将使资源类型显示为 "users"
  set_id :id        # 指明哪个字段作为资源的唯一标识符

  # 2. 定义需要序列化的属性
  # 这里的属性名必须与你的 User 模型中的字段名一致
  attributes :username, :nickname, :email, :online_status, :created_at, :updated_at
  # 重要提示：出于安全考虑，切勿在这里直接包含敏感信息如 :passwd。
  # 密码（如果使用了 password_digest）通常只在认证过程中验证，而不是暴露在 API 响应中。

  # 3. 定义关联（如果需要）
  # 这些关联会根据 JSON:API 的 `include` 参数来加载
  # 示例：一个用户创建了多个房间
  has_many :created_rooms, serializer: :room # 假设你将创建 RoomSerializer

  # 示例：一个用户发送了多条消息
  has_many :sent_messages, class_name: "Message", foreign_key: :sender_id, serializer: :message # 假设你将创建 MessageSerializer

  # 示例：一个用户可以是多个房间的成员（通过 Member 中间表）
  has_many :members # User has_many members, 关联到 MemberSerializer
  has_many :rooms, through: :members, serializer: :room # User has_many rooms through members, 关联到 RoomSerializer
end
