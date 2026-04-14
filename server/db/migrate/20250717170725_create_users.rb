class CreateUsers < ActiveRecord::Migration[7.2]
  def change
    create_table :users do |t|
      t.string :username, limit: 16
      t.string :nickname, limit: 64
      t.string :email, limit: 100
      t.string :passwd, limit: 255
      t.boolean :online_status

      t.timestamps
    end
    add_index :users, :username, unique: true
    add_index :users, :email, unique: true
  end
end
