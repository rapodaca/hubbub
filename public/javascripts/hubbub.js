Hubbub = { }

// Hubbub.isLoggedIn = function () {
//   return $.cookie('user_credentials') !== null;
// };

$(document).ready(function() {
  // display humanized Rails flash messages
  
  var message = null;
  if ($('#message')) {
    message = $('#message').text();
    humanMsg.displayMsg(message);
  }
});
