# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $('#scheduled_scheduleDate').datepicker format: 'yyyy-mm-dd'
  $('#scheduled_endDate').datepicker format: 'yyyy-mm-dd'
  return