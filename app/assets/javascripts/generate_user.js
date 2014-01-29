(function($) {
    'use strict';
    $.fn.generate_user = function() {
        this.each(function() {
            var org_id = $(this).parent().parent().attr('id');
            $(this).click(function() {
                $.ajax({
                    type: 'POST',
                    url: '/orphans/orphans_remote',
                    data: { id: org_id},
                    dataType: 'json',
                    success: function(data) {
                        $('#' + org_id + ' .response').text(data);
                        return false;
                    },
                    error: function(data) {
                        $('#' + org_id + ' .response').text(data);
                        return false;
                    }
                });
                return false
            });
        });
    }
})(jQuery);