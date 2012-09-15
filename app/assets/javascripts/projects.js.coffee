# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$(document).ready ->

new AjaxSelect()

class AjaxSelect
	constructor: ->
	ajax_select_project_type: (project_number) ->
		$.ajax
			type: "GET"
			url: "/projects#ajax_project_type"
			data: "project_number=" + project_number
			success: function(msg) 
				$('#project_area').html(msg)
			
