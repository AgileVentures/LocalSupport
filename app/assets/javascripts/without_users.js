// for organization_reports/without_users_index.html.erb
//= require bootstrap-sortable

(function ($) {
    'use strict';
    $.fn.generate_users = function () {
        $(this).click(function () {
            var values = [],
                checks = $('input:checked');
            checks.each(function () {
                values.push({
                    id: $(this).attr('data-id'),
                    email: $(this).attr('data-email')
                })
            });
            $.ajax({
                type: 'POST',
                url: '/organization_reports/without_users',
                data: JSON.stringify({ values: values }),
                dataType: 'json',
                contentType: 'application/json',
                success: function (data) {
                    checks.each(function () {
                        var parent = $(this).closest('td'),
                            row = $(this).closest('tr'),
                            id = row.attr('id'),
                            res = data[id];
                        parent.html(res);
                        if (res.match(/Error:/g)) {
                            row.addClass("alert alert-error")
                        } else {
                            row.addClass("alert alert-success")
                        }
                    });
                },
                error: function (data) {
                }
            });
            return false
        });
    };
    $.fn.select_all = function () {
        var that = $(this);
        that.click(function () {
            var active = that.hasClass('active'),
                checks = $('input:checkbox');
            checks.each(function () {
                $(this).prop('checked', !active);
            });
        });
    };
})(jQuery);

$(function () {
    $('#generate_users').generate_users();
    $('#select_all').select_all();
    var toolbar = $('#toolbar');
    if (toolbar.length != 0) {
        toolbar.affix({
            offset: { top: toolbar.offset().top }
        })
    }
});