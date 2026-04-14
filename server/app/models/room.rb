class Room < ApplicationRecord

  # 关系定义
  has_many :messages
  has_many :members
  belongs_to :creator, class_name: "User", foreign_key: "creator_id"
  has_many :users, through: :members
end
