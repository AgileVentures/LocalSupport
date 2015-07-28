
$(document).ready(function () {

  jQuery.validator.addMethod('emailVal', function(value, element) {
    // allow any non-whitespace characters as the host part
    return this.optional( element ) || /^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@(?:\S{1,63})$/.test( value );
  }, 'Please enter a valid email address');


  $('.edit_organisation').validate({ // initialize the Plugin

    rules: {

      "organisation[email]": {
          // other rules,
          required: true,
          emailVal: true // <-  declare the rule someplace!
      }

    },

    errorPlacement: function(error, element) {
      error.insertBefore(element);
    }

  });

});