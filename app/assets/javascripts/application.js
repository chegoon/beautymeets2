// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require foundation
//= require jquery.purr
//= require best_in_place
//= require autocomplete-rails
//= require underscore
//= require gmaps/google
//= require jquery_nested_form
//= require sticky_footer.js

$(function(){ $(document).foundation(); });

// The below code works for full height
$(function() {
	var timer;
	
	$(window).resize(function() {
		clearTimeout(timer);
		timer = setTimeout(function() {
			$('.inner-wrap').css("min-height", $(window).height() + "px" );
			$('.main-section').css("min-height", $(window).height() + "px" );
		}, 40);
	}).resize();
});

// The function for toggle bookmark
function swapBookmarkImage()
{
    var origSrc = jQuery("img#bookmark_star").attr('src');

    // Change the image src toggle based on the current image
    if ( origSrc == '/images/star_bookmark_disabled.png' ) {
        var newSrc = '/images/star_bookmark_enabled.png';
    }
    else {
        var newSrc = '/images/star_bookmark_disabled.png';
    };
    
    // Swap out the image
    jQuery("img#bookmark_star").attr('src', newSrc);
}