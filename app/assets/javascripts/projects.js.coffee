# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
$(document).ready ->
	new PictureCropper()

class PictureCropper
	constructor: ->
		$('#cropbox2').Jcrop
			aspectRatio: 1
			setSelect: [0, 0, 600, 600]
			onSelect: @update
			onChange: @update

	update: (coords) => 
		$('#project_crop_x').val(coords.x)
		$('#project_crop_y').val(coords.y)
		$('#project_crop_w').val(coords.w)
		$('#project_crop_h').val(coords.h)
		@updatePreview(coords)

	updatePreview: (coords) => 
  	$('#preview2').css
    	width: Math.round(100/coords.w * $('#cropbox2').width()) + 'px'
    	height: Math.round(100/coords.h * $('#cropbox2').height()) + 'px'
    	marginLeft: '-' + Math.round((100/coords.w) * coords.x) + 'px'
    	marginTop: '-' + Math.round((100/coords.h) * coords.y) + 'px'
