$(document).ready(function() {
  var roomId = $('#messages').attr('room_id');
  App.room = App.cable.subscriptions.create({channel: "RoomChannel", room_id: roomId}, {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      if ($('#messages').attr('current_user') == data['user_id']) {
        $('#messages').append(data['message']);
        scrollToLastMessage();
      } else {
        $('#messages').append(data['message_other']);
        // console.log(data['msg']);
        if (Notification.permission === 'granted') {
          var title = 'Messages'
          var body = data['msg']["name"] +": "+ data['msg']["content"]
          var options = { body: body }
          new Notification(title, options)
        }
      }
    },
    speak: function(message, user_id, room_id) {
      this.perform('speak', {
        message: message,
        user_id: user_id,
        room_id: room_id
      });
    }
  });
});
$(document).on('turbolinks:load', function() {
  scrollToLastMessage();
});

function scrollToLastMessage() {
  $('#messages').animate({
    scrollTop: $('#messages').get(0).scrollHeight
    },
    'fast'
  );
};
