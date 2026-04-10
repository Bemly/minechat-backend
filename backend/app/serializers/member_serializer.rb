class MemberSerializer
  include JSONAPI::Serializer

  set_type :member
  set_id :id

  attributes :joined_at, :created_at, :updated_at

  # 关联定义
  belongs_to :room, serializer: :room
  belongs_to :user, serializer: :user
  belongs_to :unread_message, class_name: "Message", foreign_key: :unread_id, serializer: :message, optional: true
end
