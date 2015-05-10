(function(LSUtilities, $) {
    LSUtilities.unfurlToSignUp = function(){
        var menu = $('#menuLogin');
        var register = $('#registerForm');
        if (!jQuery.contains(document, $('.in')[0])) {
            $('.nav-collapse').collapse('show');
        }
        if (!menu.hasClass('open')) {
            menu.addClass('open');
        }
        if(!register.hasClass('in')){
            $('#toggle_link').click();
        }
    };
}(window.LSUtilities = window.LSUtilities || {}, jQuery));
