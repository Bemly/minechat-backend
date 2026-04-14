class Member < ApplicationRecord

  # 关系定义
  belongs_to :room
  belongs_to :user
  belongs_to :unread_message, class_name: "Message", foreign_key: "unread_id", optional: true # unread_id 可能是 NULL

end
