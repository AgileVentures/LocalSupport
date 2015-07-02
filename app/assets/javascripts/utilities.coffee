window.LSUtilities = window.LSUtilities || {}
$ = jQuery
window.LSUtilities.unfurlToSignUp = () ->
    menu = $('#menuLogin');
    register = $('#registerForm');
    if !jQuery.contains(document, $('.in')[0])
        $('.nav-collapse').collapse('show')
    if (!menu.hasClass('open'))
        menu.addClass('open')
    if(!register.hasClass('in'))
        $('#toggle_link').click()
