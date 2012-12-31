# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->

	$('#project_list').sortable 
		axis: 'y'
		update: -> 
			$.post($(this).data('update-url'), $(this).sortable('serialize'))

	new AvatarCropper()

class AvatarCropper
	constructor: ->
		$('#cropbox').Jcrop
			aspectRatio: 1
			setSelect: [0, 0, 600, 600]
			onSelect: @update
			onChange: @update

	update: (coords) => 
		$('#page_crop_x').val(coords.x)
		$('#page_crop_y').val(coords.y)
		$('#page_crop_w').val(coords.w)
		$('#page_crop_h').val(coords.h)
		@updatePreview(coords)

	updatePreview: (coords) => 
  	$('#preview1').css
    	width: Math.round(100/coords.w * $('#cropbox').width()) + 'px'
    	height: Math.round(100/coords.h * $('#cropbox').height()) + 'px'
    	marginLeft: '-' + Math.round((100/coords.w) * coords.x) + 'px'
    	marginTop: '-' + Math.round((100/coords.h) * coords.y) + 'px'
