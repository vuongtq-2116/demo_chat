class MessagesController < ApplicationController
  before_action :authenticate_user!

  def new
    @message = Message.new
  end

  def create
    return if params["message"]["content"].blank?

    @room = Room.find_by id: params["message"]["room_id"]
    @message = @room.messages.new message_params
    @message.user = current_user

    if @message.save
      unread_msg = UnreadMessage.find_or_create_by! user: current_user, room: @room

      unread_msg.update! seen_at: @message.created_at if unread_msg

      users_in_room = Permission.where(room: @room, status: :approved)
                                .except_owner(current_user.id)
                                .pluck(:user_id)

      p users_in_room
      users_in_room.each do |user_id|
        ActionCable.server.broadcast(
          "activity_#{user_id}_channel",
          [{room: {name: @room.name, id: @room.id}, user: current_user.name, content: @message.content}, "send_message"]
        )
      end

      respond_to do |format|
        format.js { render layout: false, content_type: "text/javascript" }
      end
    else
      render room_path(@room.id)
    end
  end

  private
  def message_params
    params.require(:message).permit :content, :image, :user_id, :room_id
  end
end
