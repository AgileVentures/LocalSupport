
$(document).ready(function () {

  jQuery.validator.addMethod('emailVal', function(value, element) {
    // allow any non-whitespace characters as the host part
    var mailRegex = /^[-a-z0-9~!$%^&*_=+}{\'?]+(\.[-a-z0-9~!$%^&*_=+}{\'?]+)*@([a-z0-9_][-a-z0-9_]*(\.[-a-z0-9_]+)*\.(aero|arpa|biz|com|coop|edu|gov|info|int|mil|museum|name|net|org|pro|travel|mobi|[a-z][a-z])|([0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}))(:[0-9]{1,5})?$/i
    return this.optional( element ) || mailRegex.test( value );
  }, 'Please enter a valid email address');

  jQuery.validator.addMethod("websiteVal", function(value, element) {
    var urlRegex = /(?:\S+(?::\S*)?@)?(?:(?!10(?:\.\d{1,3}){3})(?!127(?:\.\d{1,3}){3})(?!169\.254(?:\.\d{1,3}){2})(?!192\.168(?:\.\d{1,3}){2})(?!172\.(?:1[6-9]|2\d|3[0-1])(?:\.\d{1,3}){2})(?:[1-9]\d?|1\d\d|2[01]\d|22[0-3])(?:\.(?:1?\d{1,2}|2[0-4]\d|25[0-5])){2}(?:\.(?:[1-9]\d?|1\d\d|2[0-4]\d|25[0-4]))|(?:(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)(?:\.(?:[a-z\u00a1-\uffff0-9]+-?)*[a-z\u00a1-\uffff0-9]+)*(?:\.(?:[a-z\u00a1-\uffff]{2,})))(?::\d{2,5})?(?:\/[^\s]*)?$/i;
    return this.optional(element) || urlRegex.test(value);
  }, "Please enter a valid website address");


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
        required: true,
        emailVal: true
      },

      "organisation[website]": {
        websiteVal: true
      }

    },

    errorPlacement: function(error, element) {
      error.insertBefore(element);
    }

  });

});