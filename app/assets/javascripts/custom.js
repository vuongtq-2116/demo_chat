$("#messages").animate({scrollTop:0},500);

$("input[type=file]").on("change", function() {
  $("#preview").attr("src", URL.createObjectURL(this.files[0]));
});

$(function(){
  var yd=$('#messages');
  var lastScrollTop=Infinity;
  yd.scrollTop(yd.prop("scrollHeight") - yd.prop("clientHeight")).on('wheel',wheel);

  function loadMoreOnTop(){
    var msg_ids = $('p').map(function () {
      return $(this).attr("data-msg-id");
    });

    var min_id = Math.min.apply(Math, msg_ids);

    $.ajax({
      url: '<%=load_more_path%>',
      type: "GET",
      data: {"id_msg" : min_id, "room_id" : yd.attr("room_id")},
      success: function(response) {
      }
    });
  };

  function loadMoreOnBottom(){
    var msg_ids = $('p').map(function () {
      return $(this).attr("data-msg-id");
    });
    var max_id = Math.max.apply(Math, msg_ids);
    // console.log(max_id);
    $.ajax({
      url: '<%=load_more_unread_path%>',
      type: "GET",
      data: {"id_msg" : max_id, "room_id" : yd.attr("room_id")},
      success: function(response) {
      }
    });
  };
  var bot = 0;

  function wheel(){
    var st=$(this).scrollTop();
      if (st<=lastScrollTop && st<300){
        getMore();
      } else {
        bot++;
        if(bot == 1 || bot%12 == 0) loadMoreOnBottom();
      }
      lastScrollTop=st;
  };

  function getMore(){
    loadMoreOnTop();

    var lastHeight=yd.prop("scrollHeight");
    yd.scrollTop(yd.prop("scrollHeight")-lastHeight+4);
    yd.off("wheel",wheel);
    setTimeout(function(){
        yd.on('wheel',wheel);
    },300);
  };
});
