class RoomsController < ApplicationController
  def index
    render Rooms::Index.new(rooms: fetch_rooms)
  end

  def show
    render Rooms::Show.new(room: fetch_room(params[:id]), messages: fetch_room_messages(params[:id]))
  end

  def new
    render Rooms::New.new
  end

  def create
    response = ApiClient.create_room(room_params)
    if response&.dig("data")
      redirect_to rooms_path, notice: "房间创建成功"
    else
      room = room_params.to_unsafe_h || {}
      errors = response&.dig("errors") || ["创建失败"]
      render Rooms::New.new(room: room, errors: errors), status: :unprocessable_entity
    end
  end

  def edit
    render Rooms::Edit.new(room: fetch_room(params[:id]))
  end

  def update
    response = ApiClient.update_room(params[:id], room_params)
    if response&.dig("data")
      redirect_to rooms_path, notice: "房间更新成功"
    else
      room = fetch_room(params[:id])
      errors = response&.dig("errors") || ["更新失败"]
      render Rooms::Edit.new(room: room, errors: errors), status: :unprocessable_entity
    end
  end

  def destroy
    ApiClient.destroy_room(params[:id])
    redirect_to rooms_path, notice: "房间已删除"
  end

  private

  def fetch_rooms
    response = ApiClient.rooms
    response&.dig("data") || []
  rescue StandardError
    []
  end

  def fetch_room(id)
    response = ApiClient.room(id)
    response&.dig("data") || {}
  rescue StandardError
    {}
  end

  def fetch_room_messages(room_id)
    response = ApiClient.room_messages(room_id)
    response&.dig("data") || []
  rescue StandardError
    []
  end

  def room_params
    params.require(:room).permit(:name, :creator_id, :room_type)
  end
end
