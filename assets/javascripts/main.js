$(document).ready(function() {

  $.get('https://pnpcptp8xh9k.statuspage.io/api/v2/status.json').then(function(response) {
    if(response.status && response.status.indicator) {
      $('.status-circle').addClass(response.status.indicator);
    }
  });


  $('#toggle-menu').on('click', function() {

    $('#sidebar').toggleClass('is-open');
    $('.wrapper').toggleClass('is-fixed')
    if ($('#sidebar').hasClass('is-open')) {
      $(this).text('Close');
    } else {
      $(this).text('Menu');
    }

  });

});