$(document).ready(function () {

  $.get('https://pnpcptp8xh9k.statuspage.io/api/v2/status.json').then(function(response) {
    if(response.status && response.status.indicator) {
      $('.status-circle').addClass(response.status.indicator);
    }
  });


  $('#toggle-menu').on('click', function () {
    $('#sidebar').toggleClass('is-open');
    $('.wrapper').toggleClass('is-fixed')
    if ($('#sidebar').hasClass('is-open')) {
      $(this).text('Close');
    } else {
      $(this).text('Menu');
    }

  });



  var sidebarToggle = function () {
    $('.sidebar-navigation').addClass('has-js');

    var sectionStorageId = 'travis-docs-nav';
    var storageContent = window.localStorage.getItem(sectionStorageId);
    var linkStorageId = 'travis-docs-current';
    var linkStorageContent = window.localStorage.getItem(linkStorageId);
    var anchorWithStoragePath = $('.sidebar-navigation a[href="'+ linkStorageContent +'"]');
    var currentPath = window.location.pathname;
    var anchorWithCurrentPath = $('a[href="'+ currentPath +'"]');

    if (currentPath !== '/') {
      if (linkStorageContent && storageContent) {
        if (anchorWithStoragePath.attr('href') === anchorWithCurrentPath.attr('href')) {
          anchorWithStoragePath.addClass('is-active');
          $('.sidebar-navigation h3:contains('+ storageContent +')').addClass('is-open');
          $('.sidebar-navigation h3:contains('+ storageContent +')').next('ul').addClass('is-open');
        } else {
          anchorWithCurrentPath.addClass('is-active');
          anchorWithCurrentPath.parents('ul').addClass('is-open');
        }      
      } else {
        anchorWithCurrentPath.addClass('is-active');
        anchorWithCurrentPath.parents('ul').addClass('is-open');
      }
    } else {
      $('.sidebar-navigation h3:first-of-type').addClass('is-open');
      $('.sidebar-navigation ul:first-of-type').addClass('is-open');
    }

    $('.sidebar-navigation nav h3').click(function(ev) {
      ev.preventDefault();
      if ($(ev.target).hasClass('is-open')) {
        $('.sidebar-navigation .is-open').removeClass('is-open');
        window.localStorage.setItem(sectionStorageId, "");
      } else {
        window.localStorage.setItem(sectionStorageId, $(ev.target).text());
        $('.sidebar-navigation .is-open').removeClass('is-open');
        $(this).addClass('is-open');
        $(this).next('ul').addClass('is-open');
        
        if ($(ev.target).offset().top < $(window).scrollTop()) {
          $('body').animate({scrollTop: $(ev.target).offset().top});
        }
      }
    });

    $('.sidebar-navigation a').click(function(ev) {
      window.localStorage.setItem(linkStorageId, $(ev.target).attr('href'));
      $('.sidebar-navigation a.is-active').removeClass('is-active');
      $(this).addClass('is-active');
    });

  }();

  
});
