(function($) {
    'use strict';
    $.fn.TIMO = function() {
        // do I use #TIMO or this?
        $('#TIMO').on('click', function() {
            if (this.attr('signed_in') === 'false') {
                var nav  = $('.nav-collapse'),
                    menu = $('#menuLogin');
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