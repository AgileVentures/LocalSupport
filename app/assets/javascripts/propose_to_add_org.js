(function($){
    'use strict';
    $.fn.PTAO = function(){
        var that = this;
        $(this).click(function(e) {
          var menu = $('#menuLogin');
          var register = $('#registerForm');
          if (that.attr('data-signed_in') === 'false') {
              LSUtilities.unfurlToSignUp();
          }
          $('#registerForm div').first().append("<input name='user[proposed_org]' type='hidden' value='true'>");
          return false;
        });	
    };
})(jQuery);

$(function(){
    $('#add_org').PTAO();
});
