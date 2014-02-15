//= require bootstrap-sortable

(function($) {
    'use strict';
    $.fn.generate_user = function() {
        this.each(function() {
            var org_id = $(this).closest('tr').attr('id');
            $(this).click(function() {
                $.ajax({
                    type: 'POST',
                    url: '/organization_reports/without_users',
                    data: { id: org_id},
                    dataType: 'json',
                    success: function(data) {
                        $('#' + org_id + ' .response a').remove();
                        $('#' + org_id + ' .response span').text(data);
                    },
                    error: function(data) {
                        $('#' + org_id + ' .response span').text(data);
                    }
                });
                return false
            });
        });
    };
//    $.fn.generate_user_success = function(org_id, data) {
//        var matcher = $('#' + org_id + ' .response');
//        $(matcher + ' a').remove();
//        $(matcher + 'span').text(data)
//    }
})(jQuery);

$(function() {
    $('.generate_user').generate_user();
});
