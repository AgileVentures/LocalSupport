(function($) {
    'use strict';
    $.fn.generate_user = function() {
        this.each(function() {
            var org_id = $(this).closest('tr').attr('id');
            $(this).click(function() {
                $.ajax({
                    type: 'POST',
                    url: '/orphans',
                    data: { id: org_id},
                    dataType: 'json',
                    success: function(data) {
                        $('#' + org_id + ' .response span').text(data);
                    },
                    error: function(data) {
                        $('#' + org_id + ' .response span').text(data);
                    }
                });
                return false
            });
        });
    }
})(jQuery);