Hubbub = { }

Hubbub.isLoggedIn = function () {
  return $.cookie('user_credentials') !== null;
};

$(document).ready(function() {
  if (Hubbub.isLoggedIn()) {
    $('#admin').show();
  }
});
