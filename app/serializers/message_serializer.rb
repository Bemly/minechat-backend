class MessageSerializer
  include JSONAPI::Serializer

  set_type :message
  set_id :id

  attributes :content, :message_type, :timestamp, :read_status, :created_at, :updated_at

  # 关联定义
  belongs_to :sender, class_name: "User", foreign_key: :sender_id, serializer: :user
  belongs_to :room, serializer: :room
  has_many :members_who_last_read, serializer: :member # 指向 MemberSerializer
end
