class User < ApplicationRecord

  # 关系定义
  has_many :sent_messages, class_name: "Message", foreign_key: "sender_id"
  has_many :created_rooms, class_name: "Room", foreign_key: "creator_id"
  has_many :members
  has_many :rooms, through: :members
end
