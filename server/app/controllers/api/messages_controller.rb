class Api::MessagesController < ApplicationController
  before_action :set_message, only: [:show, :update, :destroy]
  before_action :set_room_for_nested, only: [:index, :create]

  # GET /api/rooms/:room_id/messages
  def index
    if @room_for_nested
      @messages = @room_for_nested.messages.order(timestamp: :asc)
    else
      @messages = Message.all.order(timestamp: :asc)
    end
    marshal_render(@messages)
  end

  # GET /api/messages/:id
  def show
    marshal_render(@message)
  end

  # POST /api/rooms/:room_id/messages
  def create
    message_params_with_room = message_params.merge(room_id: @room_for_nested.try(:id))
    @message = Message.new(message_params_with_room)

    if @message.save
      marshal_render(@message, status: :created)
    else
      marshal_render({ errors: @message.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # PATCH/PUT /api/messages/:id
  def update
    if @message.update(message_params)
      marshal_render(@message)
    else
      marshal_render({ errors: @message.errors.full_messages }, status: :unprocessable_entity)
    end
  end

  # DELETE /api/messages/:id
  def destroy
    @message.destroy
    head :no_content
  end

  private

  def set_message
    @message = Message.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "Message not found" }, status: :not_found)
  end

  def set_room_for_nested
    if params[:room_id].present?
      @room_for_nested = Room.find(params[:room_id])
    end
  rescue ActiveRecord::RecordNotFound
    marshal_render({ error: "Room not found" }, status: :not_found)
  end

  def message_params
    params.require(:message).permit(:sender_id, :content, :message_type, :timestamp, :read_status)
  end
end
