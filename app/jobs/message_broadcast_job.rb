class MessageBroadcastJob < ApplicationJob
  queue_as :default

  def perform message
    return if message.content.blank?

    ActionCable.server.broadcast "room_#{message.room_id}_channel",
      msg: {content: message.content, name: message.user.name},
      room_id: message.room.id,
      user_id: message.user.id,
      message: render_message_user(message),
      message_other: render_message_other(message)
  end

  private

  def render_message_user message
    ApplicationController.render(partial: 'messages/message', locals: {message: message})
  end

  def render_message_other message
    ApplicationController.render(partial: 'messages/message_other', locals: {message: message})
  end
end
