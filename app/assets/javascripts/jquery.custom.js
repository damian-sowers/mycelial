
/*-----------------------------------------------------------------------------------*/
/*	Remove JavaScript fallback class
/*-----------------------------------------------------------------------------------*/
 
jQuery('#container').removeClass('js-disabled');
 

jQuery(document).ready(function() {


/*-----------------------------------------------------------------------------------*/
/*	Widget Overlay Stuff
/*-----------------------------------------------------------------------------------*/
	
	var widgetOverlay = jQuery('#widget-overlay-container');
	var widgetTrigger = jQuery('#overlay-open a');
	
	var widgetOverlayHeight = widgetOverlay.height() + 3;

	widgetOverlay.css({
		marginTop : -widgetOverlayHeight,
		display : 'block'
	});
	
	widgetTrigger.toggle( function() {
		
		widgetOverlay.animate({
			marginTop : 0
		}, 800, 'easeOutBounce');
		
		widgetTrigger.addClass('close');
	
	}, function() {
		
		widgetOverlay.animate({
			marginTop : -widgetOverlayHeight
		}, 800, 'easeOutBounce');
		
		widgetTrigger.removeClass('close');
		
	});
		  
/*-----------------------------------------------------------------------------------*/
/*	Masonry Layout
/*-----------------------------------------------------------------------------------*/
	
	if(jQuery().masonry) {
		
		// cache masonry wrap
		var $wall = jQuery('#masonry');
		
		$wall.masonry({
			columnWidth: 380, 
			animate: true,
			animationOptions: {
				duration: 500,
				easing: 'easeInOutCirc',
				queue: false
			} ,
			itemSelector: '.hentry'
		}, function() {
			jQuery('#load-more-link').fadeIn(200);	
		});
		
		// cache masonry wrap
		var $port = jQuery('#masonry-portfolio');
		
		$port.masonry({
			singleMode: true,
			animate: true,
			animationOptions: {
				duration: 500,
				easing: 'easeInOutCirc',
				queue: false
			} ,
			itemSelector: '.hentry'
		});
		
	}
	
/*-----------------------------------------------------------------------------------*/
/*	Load More Post Functions
/*-----------------------------------------------------------------------------------*/
	
	var loadMoreLink = jQuery('#load-more-link a');

	var offset = parseInt(loadMoreLink.attr('data-offset'));
	var total_pages = parseInt(loadMoreLink.attr('data-pages'));
	var author = loadMoreLink.attr('data-author');
	var tag = loadMoreLink.attr('data-tag');
	var feed = loadMoreLink.attr('data-feed');
	var sporeprint = loadMoreLink.attr('data-sporeprint');
	var project_id = loadMoreLink.attr('data-projectid');
		
	if(!author)
		author = 0;
		
	if(!tag)
		tag = '';

	if(!feed)
		feed = 0

	if(!sporeprint)
		sporeprint = 0

	if(!project_id)
		project_id = 0
			
	function tz_loadMore() {

		loadMoreLink.click(function(e) {
			
			e.preventDefault();

			//console.log(offset);
				
				jQuery(this).unbind("click");
				
				jQuery('#new-posts').html('Loading...');

				if(feed == 1) {
					load_path = "/feed/load_more"
					load_params = "?offset=" + offset + "&tag=" + tag; 
				} else if(sporeprint == 1) {
					load_path = "/sporeprint/load_more"
					load_params = "?offset=" + offset + "&project_id=" + project_id; 
				} else {
					load_path = "/pages/load_more"
					load_params = "?author=" + author + "&offset=" + offset;
				}
				
				jQuery('#new-posts').load(load_path + load_params, function() {
					
					// create jQuery object
					$boxes = jQuery( '#new-posts .hentry' );
					
					if(jQuery().masonry) {
						$wall.append( $boxes ).masonry( { appendedContent: $boxes }, function() {
							
							tz_fancybox();
							tz_overlay();
							tz_likeInit();
							
							jQuery('#load-more-link a').bind("click", tz_loadMore());
							//this works because the var offset above the function isn't reloading every time the link is clicked, so the new value of the offset is incremented and passed into the post data to the load_more controller
							offset++;
							if(offset == total_pages) {
								jQuery('#load-more-link').hide();
								last_page = 1;
							} else {
								last_page = 0;
							}
							
						});

					}
					//need to write a new controller function for loading all of the last ones back into the screen when they hit back. 
					if(feed != 1 && sporeprint != 1) {
	        	history.pushState(null, document.title, "/pages/" + author + load_params + "&last_page=" + last_page);
	        } else if(feed == 1) {
	        	history.pushState(null, document.title, "/feed" + load_params + "&last_page="  + last_page);
	        } else {
	        	history.pushState(null, document.title, "/sporeprint/" + project_id + load_params + "&last_page="  + last_page);
	        }
    			$(window).bind("popstate", function() {
      			$.getScript(this.href);
    			});
				});
				
			//return false;
			
		});
	
	}
	
	tz_loadMore();
	
	jQuery(window).resize( function () {
		loadMoreWidth();
		contentHeight();
	});
	
	function loadMoreWidth() {
		
		var loadMoreLink = jQuery('#load-more-link a');
		var masonryWrap = jQuery('#masonry').width();
		
		if(masonryWrap > 380 && masonryWrap < 760) {
			animateWidth(loadMoreLink, 340);
			
		} else if(masonryWrap > 760 && masonryWrap < 1140) {
			animateWidth(loadMoreLink, 720);
			
		} else if(masonryWrap > 1140 && masonryWrap < 1520) {
			animateWidth(loadMoreLink, 1100);
			
		} else if(masonryWrap > 1520 && masonryWrap < 1900) {
			animateWidth(loadMoreLink, 1480);
			
		} else if(masonryWrap > 1900 && masonryWrap < 2280) {
			animateWidth(loadMoreLink, 1860);
			
		} else if(masonryWrap > 2280 && masonryWrap < 2660) {
			animateWidth(loadMoreLink, 2240);
		}
	}
	
	function animateWidth(elem, size) {
		elem.stop().animate({ width: size }, 200);
	}
	
	
	loadMoreWidth();
	
/*-----------------------------------------------------------------------------------*/
/*	PrettyPhoto Lightbox
/*-----------------------------------------------------------------------------------*/
	
	function tz_fancybox() {
		if(jQuery().fancybox) {
			jQuery("a.lightbox").fancybox({
				'transitionIn'	:	'fade',
				'transitionOut'	:	'fade',
				'speedIn'		:	300, 
				'speedOut'		:	300, 
				'overlayShow'	:	true,
				'autoScale'		:	false,
				'titleShow'		: 	false,
				'margin'		: 	10,
			});
		}
	}
	
	tz_fancybox();

/*-----------------------------------------------------------------------------------*/
/*	Overlay Animation
/*-----------------------------------------------------------------------------------*/

	function tz_overlay() {
		jQuery('.post-thumb a').hover( function() {
			jQuery(this).find('.overlay').fadeIn(250);
		}, function() {
			jQuery(this).find('.overlay').fadeOut(250);
		});
	}
	
	tz_overlay();
	
/*-----------------------------------------------------------------------------------*/
/*	Back to Top
/*-----------------------------------------------------------------------------------*/

	var topLink = jQuery('#back-to-top');

	function tz_backToTop(topLink) {
		
		if(jQuery(window).scrollTop() > 0) {
			topLink.fadeIn(200);
		} else {
			topLink.fadeOut(200);
		}
	}
	
	jQuery(window).scroll( function() {
		tz_backToTop(topLink);
	});
	
	topLink.find('a').click( function() {
		jQuery('html, body').stop().animate({scrollTop:0}, 500);
		return false;
	});
	
/*-----------------------------------------------------------------------------------*/
/*	Add title attributes
/*-----------------------------------------------------------------------------------*/

	jQuery('.nav-previous a').attr('title', jQuery('.nav-previous a').text());
	jQuery('.nav-next a').attr('title', jQuery('.nav-next a').text());
	
	function contentHeight() {
		
		var windowHeight = jQuery(window).height();
		var footerHeight = jQuery('#footer').height();
		
		jQuery('#content').css('min-height', windowHeight - footerHeight - 150);
		
	}
	
	contentHeight(); 

/*-----------------------------------------------------------------------------------*/
/*	Like Script
/*-----------------------------------------------------------------------------------*/
	
	function tz_reloadLikes(who) {
		var text = jQuery("#" + who).html();
		var patt= /(\d)+/;
		
		var num = patt.exec(text);
		num[0]++;
		text = text.replace(patt,num[0]);
		jQuery("#" + who).html('<span class="count">' + text + '</span>');
	} //reloadLikes
	
	
	function tz_likeInit() {
		jQuery(".likeThis").click(function() {
			var classes = jQuery(this).attr("class");
			classes = classes.split(" ");
			
			if(classes[1] == "active") {
				return false;
			}
			var classes = jQuery(this).addClass("active");
			var id = jQuery(this).attr("id");
			var user_id = jQuery(this).attr("data-user");
			id = id.split("like-");
			jQuery.ajax({
			  type: "POST",
			  url: "/likes/ajax_like",
			  data: "project_id=" + id[1] + "&user_id=" + user_id,
			  success: tz_reloadLikes("like-" + id[1])
			}); 
			
			
			return false;
		});
	}
	
	 tz_likeInit();

/*-----------------------------------------------------------------------------------*/
/*	loading bars 
/*-----------------------------------------------------------------------------------*/
	$(".form_submit").click(function() {
    $(".form_submit").hide();
    $("#loading-bar").show();
  });

  $("#register_button").click(function() {
    $("#register_button").hide();
    $("#register_loader").show();
  });

  

});