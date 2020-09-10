$(document).ready(function() {
  App.activity = App.cable.subscriptions.create("ActivityChannel", {
    connected: function() {},
    disconnected: function() {},
    received: function(data) {
      // if (Notification.permission === 'granted') {
      //   var title = 'Push Notification'
      //   var body = data
      //   var options = { body: body }
      //   new Notification(title, options)
      // }

      if(data[1] == "request_to_room"){
        $(".modal-request").html(data[0]);
        $('#myModal').modal('show');
        requests = $(".badge-green.data-" + data[2]);
        requests.html(parseInt(requests.text()) + 1);
      }else if(data[1] == "kick_out_of_room"){
        alert("You have been kicked out of the room " + data[0])
        $(location).attr('href',data[2]).delay( 2000 );
      }else if(data[1] == "access_user_to_room"){
        alert("You have approved to room " + data[0]["name"]);
        $(".btn-warning.req-"+data[0]["id"]).attr('class', 'approved').html("");
      }else if(data[1] == "send_message"){
        if (Notification.permission === 'granted') {
          var title = data[0]["room"]["name"]
          var body = data[0]["user"] +": "+ data[0]["content"]
          var options = { body: body }
          new Notification(title, options)
        }
        unread_msgs = $(".badge-red.data-" + data[0]["room"]["id"]);
        unread_msgs.html(parseInt(unread_msgs.text()) + 1);
      }
    }
  });
});
