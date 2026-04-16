class HomeController < ApplicationController
  def index
    render ::Home::Index.new(rooms: Room.all, users: User.all)
  rescue StandardError
    render ::Home::Index.new(rooms: [], users: [])
  end
end
