(function($) {
    'use strict';
    $.fn.TIMO = function() {
        var that = this;
        $(this).click(function() {
            var menu = $('#menuLogin');
            if (that.attr('data-signed_in') === 'false') {
                if (!jQuery.contains(document, $('.in')[0])) {
                    $('.nav-collapse').collapse('show');
                }
                if (!menu.hasClass('open')) {
                    menu.addClass('open')
                }
                this.pending_org_id = $("#user_organisation_id").val();
                $('#loginForm div').first().append("<input name='pending_organisation_id' type='hidden' value="+ this.pending_org_id+">");
                return false;
            }
        });
    }
})(jQuery);

$(function() {
    $('#TIMO').TIMO();
});
