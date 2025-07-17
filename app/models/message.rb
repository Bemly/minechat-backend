class Message < ApplicationRecord

  # 关系定义
  belongs_to :sender, class_name: "User", foreign_key: "sender_id"
  belongs_to :room
  # 如果 Member 表的 unread_id 关联到 Message，这里 Message 可以是 has_one 或 has_many :members_as_unread, depending on interpretation.
  # 基于 ERD Message "1" -- "1" Room : belongs to >, Member has unread_id pointing to Message
  # Message 并不是直接知道哪个 Member 引用了它作为 unread_id，但 Member 知道它引用了哪个 Message。
  # 所以 Message 端可以不定义与 unread_id 的直接关联，或者定义为：
  has_many :members_who_last_read, class_name: "Member", foreign_key: "unread_id" # 可选，表示哪些成员以这条消息为未读标记
end
