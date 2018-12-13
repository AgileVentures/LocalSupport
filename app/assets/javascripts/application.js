// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs
//= require twitter/bootstrap
//= require underscore
//= require bootstrap-sortable
//= require_tree ./global
//= require bootstrap-switch
//= require organisations
//= require analytics
//= require utilities
//= require jquery-readyselector
//= require doit_volunteer_ops
//= require moment
//= require fullcalendar
//= require bootstrap-datetimepicker

window.LocalSupport = {};

$(function() {
  // invoke global functions here
  $('#calendar').fullCalendar({
    header: {
      right: 'prev, next, today, month, agendaWeek'
    },
    events: '/events.json'
  });
  $('[data-behaviour~=date-and-time-picker]').datetimepicker({
    format: 'YYYY/MM/DD hh:mm'
  });

  const volunteerSearch = $('#column2 .volunteer-ops-search')

  if ($(window).width() <= 560 ) {
    volunteerSearch.prependTo('#column1 .row');
  }

  window.addEventListener('resize', function () {
    if ($(window).width() <= 560) {
      volunteerSearch.prependTo('#column1 .row');
    }else {
      $('#column1 .volunteer-ops-search').insertAfter('#column2 .container-fluid ')
    }
  });
});