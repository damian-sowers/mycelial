jQuery(document).ready(function() {
	$('.project_blocks').mouseenter(function () {
    $(this).find('.user_edit').css('display', 'none').show();
    //console.log(test);
	});
	$('.project_blocks').mouseleave(function () {
     $(this).find('.user_edit').css('display', 'none').hide();
	});
	// jQuery(function() {
 //  	$('#project_tech_tag_tokens').tokenInput('/tech_tags.json', {
 //    	theme: 'facebook',
 //    	prePopulate: $('#project_tech_tag_tokens').data('load')
 //  	});
	// });
})
