class RoomsController < ApplicationController
  def index
    render Rooms::Index.new(rooms: Room.all)
  end

  def show
    @room = Room.find(params[:id])
    render Rooms::Show.new(room: @room, messages: @room.messages.order(timestamp: :asc))
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: "房间不存在"
  end

  def new
    render Rooms::New.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to rooms_path, notice: "房间创建成功"
    else
      render Rooms::New.new(room: @room, errors: @room.errors.full_messages), status: :unprocessable_entity
    end
  end

  def edit
    @room = Room.find(params[:id])
    render Rooms::Edit.new(room: @room)
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: "房间不存在"
  end

  def update
    @room = Room.find(params[:id])
    if @room.update(room_params)
      redirect_to rooms_path, notice: "房间更新成功"
    else
      render Rooms::Edit.new(room: @room, errors: @room.errors.full_messages), status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: "房间不存在"
  end

  def destroy
    Room.find(params[:id]).destroy
    redirect_to rooms_path, notice: "房间已删除"
  rescue ActiveRecord::RecordNotFound
    redirect_to rooms_path, alert: "房间不存在"
  end

  private

  def room_params
    params.require(:room).permit(:name, :creator_id, :room_type)
  end
end
