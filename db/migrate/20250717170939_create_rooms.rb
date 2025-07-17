class CreateRooms < ActiveRecord::Migration[8.0]
  def change
    create_table :rooms do |t|
      t.string :name, limit: 100
      t.integer :creator_id
      t.string :room_type, limit: 20

      t.timestamps
    end
    add_index :rooms, :name, unique: true
  end
end
