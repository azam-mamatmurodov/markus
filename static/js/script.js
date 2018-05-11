jQuery(document).ready(function() {
	counter();
	sticky_init ();





	// $(".my-dropdown").click(function(){
	// 	$(this).children('my-dropdown-child').slideToggle(300);
	// 	$().siblings().children().next().slideUp(300);
		
	// });



	jQuery(".my-dropdown").click(function(){
		jQuery('body').toggleClass('open-notification');
		jQuery('.my-dropdown-child').slideToggle( "slow", function(){});
        jQuery(".overlay").toggleClass('overlay-show');
    });

    jQuery(".overlay").click(function(){
        jQuery('body').removeClass('open-notification');
		jQuery(".overlay").removeClass('overlay-show')
		jQuery('.my-dropdown-child').slideUp( "slow", function(){});
    });

    jQuery('.navbar .dropdown').click(function() {
        console.log('Clicked');
        jQuery(this).children('.my-dropdown-child').slideToggle();
    });


});

// counter
var is_count = true
function counter() {
	if($(".counter").length) {
		var winScr = $(window).scrollTop();
		var winHeight = $(window).height();
		var ofs = $('.counter').offset().top;

		$(window).on('scroll',function(){
			winScr = $(window).scrollTop();
			winHeight = $(window).height();
			ofs = $('.counter').offset().top;

			if ( (winScr+winHeight)>ofs && is_count) {
				$(".counter").each(function () {
					var atr = $(this).attr('data-count');
					var item = $(this);
					var n = atr;
					var d = 0;
					var c;

					item.text(d);
					var interval = setInterval(function() {
						c = atr/70;
						d += c;
						if ( (atr-d)<c) {
							d=atr;
						}
						item.text(Math.floor(d) );
						if (d==atr) {
							clearInterval(interval);
						}
					},50);
				});
				is_count = false;
			}
		})
	}
}


// menu
function sticky_init() {
	if (jQuery('.header').length) {
		var jQueryheader = jQuery( ".header" ).clone();
		jQuery('body').prepend('<div class="sticky-container"></div>');
		var sticky_contaner = jQuery('.sticky-container');
		sticky_contaner.html(jQueryheader);
		var lastScrollTop = 0;
		jQuery(window).scroll(function(event){
			var st = jQuery(this).scrollTop();
			if (st > lastScrollTop || st <= 120) {
				sticky_contaner.removeClass('sticky-on');
			} else {
				if (jQuery(window).width() <= 1000) {
					sticky_contaner.removeClass('sticky-on');
				} else {
					sticky_contaner.addClass('sticky-on');
				}
			}
			lastScrollTop = st;
		});
	}
};

$(document).ready(function () {

})