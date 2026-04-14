class CreateMessages < ActiveRecord::Migration[7.2]
  def change
    create_table :messages do |t|
      t.integer :sender_id
      t.integer :room_id
      t.text :content
      t.string :message_type, limit: 20
      t.datetime :timestamp
      t.boolean :read_status

      t.timestamps
    end
  end
end
