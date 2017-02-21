$('.doit_volunteer_ops.new, .doit_volunteer_ops.create').ready(function(){
  $.get('/doit_organisations', function() {
  })
  .fail(function(){
    console.log("error fetching Doit orgs");
  });
  $('.input-group.date').datepicker({
      format: 'yyyy-mm-dd',
      autoclose: true,
      todayHighlight: true,
      clearBtn: true
    });
});

