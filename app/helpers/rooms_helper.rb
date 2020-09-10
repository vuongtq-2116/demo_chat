module RoomsHelper
  def load_seen_at user_id, room_id
    um = UnreadMessage.find_by(user_id: user_id, room_id: room_id)
    return UnreadMessage.create(user_id: user_id, room_id: room_id, seen_at: Time.zone.now) unless um

    um
  end

  def count_unread_message room
    um = room.unread_messages.find_by user: current_user
    return 0 unless um && check_permission(room)

    Message.where("room_id = ? AND created_at > ?", room.id, um.seen_at).count
  end

  def check_permission room
    permission = Permission.find_by user: current_user, room: room, status: :approved
    return true if room.user == current_user || permission
    return false unless permission
  end

  def count_request room
    return 0 unless check_permission(room)

    room.permissions.where(room: room, status: :requesting).count
  end
end
