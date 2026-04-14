class Api::MembersController < ApplicationController
  before_action :set_room
  before_action :set_member, only: [:destroy]

  # GET /api/rooms/:room_id/members
  def index
    @members = @room.members.includes(:user)
    marshal_render(@members)
  end

  # POST /api/rooms/:room_id/members
  def create
    @member = @room.members.build(member_params.merge(joined_at: Time.current))

    if @member.save
      marshal_render(@member, status: :created)
    else
      marshal_render({ errors: @member.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # DELETE /api/rooms/:room_id/members/:id
  def destroy
    @member.destroy
    head :no_content
  end

  private

  def set_room
    @room = Room.find(params[:room_id])
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "Room not found" }, status: :not_found)
  end

  def set_member
    @member = @room.members.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "Member not found in this room" }, status: :not_found)
  end

  def member_params
    params.require(:member).permit(:user_id)
  end
end
