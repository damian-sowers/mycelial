# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery(document).ready ->
  $("#programming_project").click ->
    $("#programming_form").show()
    $("#blog_form").hide()

  $("#blog_project").click ->
   	$("#blog_form").show()
   	$("#programming_form").hide()
			
