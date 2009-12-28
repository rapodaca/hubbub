Hubbub = { }

Hubbub.renderMenu = function () {
  if($.cookie('user_credentials') != null) {
    $('#admin').append('Admin stuff goes here');
  }
}

$(document).ready(function() {
  Hubbub.renderMenu();
});