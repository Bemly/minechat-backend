class CreateMembers < ActiveRecord::Migration[8.0]
  def change
    create_table :members do |t|
      t.integer :room_id
      t.integer :user_id
      t.datetime :joined_at
      t.integer :unread_id

      t.timestamps
    end
  end
end
