(function($) {
    'use strict';
    $.fn.TIMO = function() {
        var that = this;
        $(this).on('click', function() {
            var menu = $('#menuLogin');
            if (that.attr('data-signed_in', 'false')) {
                if (!jQuery.contains(document, $('.in')[0])) {
                    $('.nav-collapse').collapse('show');
                }
                if (!menu.hasClass('open')) {
                    menu.addClass('open')
                }
                return false
            }
        });
    }
})(jQuery);