class RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]

  # GET /rooms
  def index
    @rooms = Room.all
    # 可以选择包含关联数据，例如创建者信息或成员信息
    render json: RoomSerializer.new(@rooms, include: [:creator, :members, :users]).serializable_hash
  end

  # GET /rooms/:id
  def show
    render json: RoomSerializer.new(@room, include: [:creator, :members, :users, :messages]).serializable_hash
  end

  # POST /rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      render json: RoomSerializer.new(@room).serializable_hash, status: :created
    else
      render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /rooms/:id
  def update
    if @room.update(room_params)
      render json: RoomSerializer.new(@room).serializable_hash, status: :ok
    else
      render json: { errors: @room.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/:id
  def destroy
    @room.destroy
    head :no_content
  end

  private

  def set_room
    @room = Room.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Room not found" }, status: :not_found
  end

  def room_params
    # 注意：creator_id 通常由当前认证用户自动填充，而不是通过参数直接传递
    # 这里为了匹配 ERD 暂时保留，但实际应用中需要更严格的安全控制
    params.require(:room).permit(:name, :creator_id, :room_type)
  end
end
