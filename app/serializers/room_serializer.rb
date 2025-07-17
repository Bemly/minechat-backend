class RoomSerializer
  include JSONAPI::Serializer
  set_type :room
  set_id :id

  attributes :name, :room_type, :created_at, :updated_at

  # 关联定义
  belongs_to :creator, class_name: "User", foreign_key: :creator_id, serializer: :user
  has_many :messages, serializer: :message
  has_many :members, serializer: :member
  has_many :users, through: :members, serializer: :user
end
