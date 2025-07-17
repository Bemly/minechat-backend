class MembersController < ApplicationController
  before_action :set_room
  before_action :set_member, only: [:destroy] # Member 的 show 和 update 通常不暴露或在其他上下文中

  # GET /rooms/:room_id/members
  def index
    @members = @room.members.includes(:user) # 包含用户数据以便序列化
    render json: MemberSerializer.new(@members, include: [:user]).serializable_hash
  end

  # POST /rooms/:room_id/members
  def create
    # 这里假设前端传递 user_id 来添加成员
    # 实际应用中，你可能需要验证该用户是否存在，并且该用户尚未在该房间中
    @member = @room.members.build(member_params.merge(joined_at: Time.current))

    if @member.save
      render json: MemberSerializer.new(@member).serializable_hash, status: :created
    else
      render json: { errors: @member.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /rooms/:room_id/members/:id (移除特定成员)
  def destroy
    # 也可以考虑通过 user_id 来移除，例如 /rooms/:room_id/members/remove_user?user_id=X
    @member.destroy
    head :no_content
  end

  # 注意：通常不会有 /members/:id 的 show 和 update，因为成员是在房间的上下文中操作的。
  # 如果需要更新 unread_id，可以考虑为 Message 或 User 提供一个更新已读状态的端点。

  private

  # 在所有动作前设置所属的 Room
  def set_room
    @room = Room.find(params[:room_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Room not found" }, status: :not_found
  end

  # 在 destroy 动作前设置要操作的 Member
  def set_member
    @member = @room.members.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Member not found in this room" }, status: :not_found
  end

  def member_params
    # 通常只允许 user_id 被客户端传入，joined_at 和 unread_id 由服务器管理
    params.require(:member).permit(:user_id) # unread_id 通常在服务器端更新
  end
end
