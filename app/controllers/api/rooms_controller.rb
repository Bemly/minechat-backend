class Api::RoomsController < ApplicationController
  before_action :set_room, only: [:show, :update, :destroy]

  # GET /api/rooms
  def index
    @rooms = Room.all
    marshal_render(@rooms)
  end

  # GET /api/rooms/:id
  def show
    marshal_render(@room)
  end

  # POST /api/rooms
  def create
    @room = Room.new(room_params)
    if @room.save
      marshal_render(@room, status: :created)
    else
      marshal_render({ errors: @room.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/rooms/:id
  def update
    if @room.update(room_params)
      marshal_render(@room)
    else
      marshal_render({ errors: @room.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # DELETE /api/rooms/:id
  def destroy
    @room.destroy
    head :no_content
  end

  private

  def set_room
    @room = Room.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "Room not found" }, status: :not_found)
  end

  def room_params
    params.require(:room).permit(:name, :creator_id, :room_type)
  end
end
