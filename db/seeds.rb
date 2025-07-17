# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

puts "Creating users..."
user1 = User.find_or_create_by!(username: "alice", nickname: "爱丽丝", email: "alice@example.com", passwd: "password123", online_status: true)
user2 = User.find_or_create_by!(username: "bob", nickname: "鲍勃", email: "bob@example.com", passwd: "password123", online_status: false)
user3 = User.find_or_create_by!(username: "charlie", nickname: "查理", email: "charlie@example.com", passwd: "password123", online_status: false)
puts "Users created."

puts "Creating rooms..."
room1 = Room.find_or_create_by!(name: "General Chat", creator: user1, room_type: "public")
room2 = Room.find_or_create_by!(name: "Private Group", creator: user2, room_type: "private")
puts "Rooms created."

puts "Adding members to rooms..."
Member.find_or_create_by!(room: room1, user: user1, joined_at: Time.current)
Member.find_or_create_by!(room: room1, user: user2, joined_at: Time.current)
Member.find_or_create_by!(room: room2, user: user2, joined_at: Time.current)
Member.find_or_create_by!(room: room2, user: user3, joined_at: Time.current)
puts "Members added."

puts "Creating messages..."
Message.find_or_create_by!(sender: user1, room: room1, content: "Hello everyone!", message_type: "text", timestamp: 1.minute.ago)
Message.find_or_create_by!(sender: user2, room: room1, content: "Hi Alice!", message_type: "text", timestamp: Time.current)
Message.find_or_create_by!(sender: user2, room: room2, content: "Secret message here.", message_type: "text", timestamp: 30.seconds.ago)
puts "Messages created."
