class MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]
  before_action :set_room_for_nested, only: [:index, :create] # 用于处理嵌套路由 /rooms/:room_id/messages

  # GET /messages (如果需要所有消息，但通常通过房间访问)
  # GET /rooms/:room_id/messages (嵌套路由)
  def index
    if @room_for_nested # 如果是嵌套路由，则只获取该房间的消息
      @messages = @room_for_nested.messages.order(timestamp: :asc) # 假设按时间戳排序
    else # 否则获取所有消息（如果路由允许）
      @messages = Message.all.order(timestamp: :asc)
    end
    render json: MessageSerializer.new(@messages, include: [:sender, :room]).serializable_hash
  end

  # GET /messages/:id
  def show
    render json: MessageSerializer.new(@message, include: [:sender, :room]).serializable_hash
  end

  # POST /messages (如果路由允许)
  # POST /rooms/:room_id/messages (嵌套路由)
  def create
    # 如果是嵌套路由，消息属于该房间
    message_params_with_room = message_params.merge(room_id: @room_for_nested.try(:id))
    @message = Message.new(message_params_with_room)

    # 实际应用中，sender_id 也应该由当前认证用户自动填充
    # @message.sender_id = current_user.id # 假设有 current_user 方法

    if @message.save
      render json: MessageSerializer.new(@message).serializable_hash, status: :created
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /messages/:id
  def update
    if @message.update(message_params)
      render json: MessageSerializer.new(@message).serializable_hash, status: :ok
    else
      render json: { errors: @message.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /messages/:id
  def destroy
    @message.destroy
    head :no_content
  end

  private

  def set_message
    @message = Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Message not found" }, status: :not_found
  end

  # 如果是嵌套在 /rooms/:room_id/messages 下，则设置 @room_for_nested
  def set_room_for_nested
    if params[:room_id].present?
      @room_for_nested = Room.find(params[:room_id])
    end
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Room not found" }, status: :not_found
  end

  def message_params
    # 注意：sender_id 和 timestamp 通常不应由客户端直接提供，而是在服务器端生成
    # 但根据你的 ERD，暂时允许传递。实际应用中需要调整。
    params.require(:message).permit(:sender_id, :content, :message_type, :timestamp, :read_status)
  end
end
