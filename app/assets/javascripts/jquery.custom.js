/*-----------------------------------------------------------------------------------

 	Custom JS - All front-end jQuery
 
-----------------------------------------------------------------------------------*/

/*-----------------------------------------------------------------------------------*/
/*	Remove JavaScript fallback class
/*-----------------------------------------------------------------------------------*/
 
jQuery('#container').removeClass('js-disabled');
 
/*-----------------------------------------------------------------------------------*/
/*	Let's get ready!
/*-----------------------------------------------------------------------------------*/

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
	var cat = parseInt(loadMoreLink.attr('data-category'));
	var author = parseInt(loadMoreLink.attr('data-author'));
	var tag = loadMoreLink.attr('data-tag');
	var date = loadMoreLink.attr('data-date');
	var searchQ = loadMoreLink.attr('data-search');
	
	if(!cat)
		cat = 0;
		
	if(!author)
		author = 0;
		
	if(!tag)
		tag = '';
		
	if(!date)
		date = 0;
	
	if(!searchQ)
		searchQ = '';
			
	function tz_loadMore() {
		
		var off = false;
	
		var currentCount = parseInt(jQuery('#post-count').text());
		
		if(currentCount == 0 ) {
			loadMoreLink.text(loadMoreLink.attr('data-empty'));
			off = true;
		}

		loadMoreLink.click(function(e) {
			var newCount = currentCount - jQuery(this).attr('data-offset');
			
			e.preventDefault();

			//console.log(offset);
			
			if(off != true) {
				
				jQuery(this).unbind("click");
				
				jQuery('#post-count').html('<img src="'+ jQuery('#post-count').attr('data-src') +'" alt="Loading..." />');
				jQuery('#remaining').html('');
				
				
				jQuery('#new-posts').load(jQuery(this).attr('data-src'), { 
				
					offset: offset,
					category: cat,
					author: author,
					tag: tag,
					date: date,
					searchQ: searchQ
					
				}, function() {
					
					// create jQuery object
					$boxes = jQuery( '#new-posts .hentry' );
					
					if(jQuery().masonry) {
						$wall.append( $boxes ).masonry( { appendedContent: $boxes }, function() {
							
							tz_fancybox();
							tz_overlay();
							tz_likeInit();
							
							if(newCount > 0 ) {
								jQuery('#load-more-link a').find('#post-count').text(newCount);
								jQuery('#remaining').text(' '+jQuery('#remaining').attr('data-text'));
							} else {
								jQuery('#load-more-link a').text(jQuery('#load-more-link a').attr('data-empty'));
								off = true;
							}
							
							jQuery('#load-more-link a').bind("click", tz_loadMore());
					
						});
					}
					
					offset = offset + parseInt(jQuery('#load-more-link a').attr('data-offset'));
				});
			}
			
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
			jQuery(this).find('.overlay').fadeIn(150);
		}, function() {
			jQuery(this).find('.overlay').fadeOut(150);
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
			id = id.split("like-");
			jQuery.ajax({
			  type: "POST",
			  url: "index.php",
			  data: "likepost=" + id[1],
			  success: tz_reloadLikes("like-" + id[1])
			}); 
			
			
			return false;
		});
	}
	
	tz_likeInit();

});