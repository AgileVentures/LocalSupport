(function($) {
    'use strict';
    $.fn.TIMO = function() {
        var that = this;
        // do I use #TIMO or this?
        $(this).on('click', function() {
            if (that.attr('data-signed_in') === 'false') {
                var nav  = $('.nav-collapse'),
                    menu = $('#menuLogin');
                // $('#menuLogin:hidden')
                if ((nav.attr('style') === undefined) || (nav.attr('style') === "height: 0px;")) {
                    nav.collapse('show');
                }
                if (menu.attr('class') === "dropdown ") {
                    menu.attr('class', 'dropdown open')
                }
                return false
            }
        });
    }
})(jQuery);