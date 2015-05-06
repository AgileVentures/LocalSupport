(function($){
    'use strict';
    $.fn.PTAO = function(){
        var that = this;
        $(this).click(function() {
          return false;        
	});	
    };
})(jQuery);

$(function(){
    $('#add_org').PTAO();
});
