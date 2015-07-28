
$(document).ready(function () {

  jQuery.validator.addMethod('emailVal', function(value, element) {
    // allow any non-whitespace characters as the host part
    mailRegex = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
    return this.optional( element ) || mailRegex.test( value );
  }, 'Please enter a valid email address');


  $('.edit_organisation').validate({ // initialize the Plugin

    rules: {

      "organisation[name]": {
        required: true
      },

      "organisation[description]": {
        required: true
      },

      "organisation[address]": {
        required: true
      },

      "organisation[postcode]": {
        required: true
      },

      "organisation[email]": {
        // other rules,
        required: true,
        emailVal: true
      }

    },

    errorPlacement: function(error, element) {
      error.insertBefore(element);
    }

  });

});