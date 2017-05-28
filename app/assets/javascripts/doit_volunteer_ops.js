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

    $('.input-group.date').datepicker({
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayHighlight: true,
      clearBtn: true
    });
  });
});

