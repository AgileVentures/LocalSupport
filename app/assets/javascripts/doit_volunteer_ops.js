$('.volunteer_ops').ready(function(){
  $('#doit_form').hide();
  $('#check_to_doit').change(function(){
    if(this.checked){
      $('#doit_form').show();
      $.get('/doit_organisations', function() {
      })
        .fail(function(){
          console.log("error fetching Doit orgs");
        });
    } else {
      $('#doit_form').hide();
    }
  });
  $('[data-behaviour~=iso-date-picker]').datetimepicker({
    format: 'YYYY-MM-DD'
  });
});
