(function($){
    'use strict';
    $.fn.PTAO = function(){
        var that = this;
        $(this).click(function(e) {
          var menu = $('#menuLogin');
          var register = $('#registerForm');
          if (that.attr('data-signed_in') === 'false') {
              if (!jQuery.contains(document, $('.in')[0])) {
                  $('.nav-collapse').collapse('show');
              }
              if (!menu.hasClass('open')) {
                  menu.addClass('open')
              }
              if(!register.hasClass('in')){
                 $('#toggle_link').click();
              }
          }
          return false;
        });	
    };
})(jQuery);

$(function(){
    $('#add_org').PTAO();
});
