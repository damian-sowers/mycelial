jQuery(document).ready(function() {
	$('.project_blocks').mouseenter(function () {
    $(this).find('.user_edit').show();
    //console.log(test);
  });
	$('.project_blocks').mouseleave(function () {
   $(this).find('.user_edit').hide();
 });

	var current_width = $(window).width();
     //do something with the width value here!
    if(current_width > 1150){
      $('.mycelial_sidebar').show();
    } else {
      $('.bottom_like_bar').show();
    }

  $(window).resize(function(){
    var current_width = $(window).width();
     //do something with the width value here!
     if(current_width < 1150){
      $('.mycelial_sidebar').hide();
      $('.bottom_like_bar').show();
     } else {
      $('.mycelial_sidebar').show();
      $('.bottom_like_bar').hide();
     }
  });
})
