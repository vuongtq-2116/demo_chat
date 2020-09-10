class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_room, only: %i(load_more load_more_unread_message)

  def index
    @rooms = Room.includes(:permissions).all
  end

  def new
    @room = current_user.rooms.new
  end

  def show
    @room = Room.find_by id: params[:id]
    unless check_permission(@room)
      redirect_to rooms_path
      return
    end
    um = UnreadMessage.find_by(user: current_user, room: @room)
    um = UnreadMessage.create! user: current_user, room: @room, seen_at: Time.zone.now unless um

    msgs = @room.messages.includes(:user).where("created_at >= ?", um.seen_at)

    @messages = if um && msgs.count >= 7
                  msgs.first(7)
                else
                  um.update! seen_at: Time.zone.now
                  @room.messages.includes(:user).last(7)
                end
    # @requests = Permission.where room: @room, status: :requesting
    @requests = @room.user == current_user ? @room.permissions.includes(:user).except_owner(current_user.id) : {}
  end

  def create
    @room = current_user.rooms.new room_params

    if @room.save
      Permission.create! user: current_user, room: @room, pms: :owner, status: :approved
      flash[:success] = "Room is created"
      redirect_to root_url
    else
      flash.now[:danger] = "Something wrong"
      render :new
    end
  end

  def load_more
    @m = @room.messages.where("id < ?", params["id_msg"]).last(5)
  end

  def load_more_unread_message
    @m = @room.messages.where("id > ?", params["id_msg"]).first(5)
    unread_msg = UnreadMessage.find_by user: current_user, room: @room

    unread_msg.update! seen_at: @m.last.created_at if unread_msg && @m.present?
  end

  def request_to_room
    Permission.create! user_id: params[:user], room_id: params[:room], pms: :user, status: :requesting
    # @pms = Permission.find_by user_id: params[:user], room_id: params[:room]
    @req_from_user = User.find_by id: params[:user]
    @room = Room.find_by id: params[:room]
    broadcast_noti @room.user.id, [ApplicationController.render(partial: "rooms/notification_req_to_owner", locals: {user: @req_from_user, room: @room}),"request_to_room", @room.id]
  end

  def access_user_to_room
    @room = Room.find_by id: params[:room], user: current_user
    return unless @room || @room.user == current_user

    @pms = Permission.find_by user_id: params[:user], room_id: params[:room], status: :requesting
    @pms.update! status: :approved
    broadcast_noti params[:user], [{name: @room.name, id: @room.id}, "access_user_to_room"]
  end

  def kick_out_of_room
    @room = Room.find_by id: params[:room], user: current_user
    return unless @room || @room.user == current_user

    @pms = Permission.find_by user_id: params[:user], room_id: params[:room]
    @pms.destroy
    broadcast_noti params[:user], [@room.name, "kick_out_of_room", root_path]
  end

  private

  def room_params
    params.require(:room).permit :name, :image
  end

  def check_permission room
    permission = Permission.find_by user: current_user, room: room, status: :approved
    return true if room.user == current_user || permission
    return false unless permission
  end

  def load_room
    @room = Room.find_by id: params["room_id"]
  end

  def broadcast_noti user_id, data
    ActionCable.server.broadcast(
      "activity_#{user_id}_channel",
      data
    )
  end
end
