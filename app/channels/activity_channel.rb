class ActivityChannel < ApplicationCable::Channel
  def subscribed
    stream_from "activity_#{current_user.id}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
