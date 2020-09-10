// $(document).on('keypress', '[data-behavior~=room_speaker]', function(event) {
//   if (event.keyCode === 13) {
//     if (!event.target.value.trim().length) {
//       return 0;
//     }
//     App.room.speak(event.target.value,
//       $("#user_id").val(),
//       $("#messages").attr("room_id")
//     );
//     event.target.value = '';
//     return event.preventDefault();
//   }
// });

// $(document).on('turbolinks:load', function() {
//   scrollToLastMessage();
// });

// function scrollToLastMessage() {
//   $('#messages').animate({
//     scrollTop: $('#messages').get(0).scrollHeight
//     },
//     'fast'
//   );
// };
// function test(){
//   var a = document.elementFromPoint(300, 450);
//   console.log(a);

// };
// $(document).on('turbolinks:load', function() {
//   test();
// });
