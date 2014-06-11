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
//= require jquery.fullpage.min.js
//= require jquery.slimscroll.min.js
//= require jquery.glide.js
//= require jquery.elastislide
//= require bootstrap-datetimepicker
//= require members.js.coffee
//= require notices.js.coffee
//= require_tree ../../../vendor/assets/javascripts/.

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

    var oriImg = jQuery("#bookmark_star a img");

    // Change the image src toggle based on the current image
    if (oriImg.attr('src') == "/assets/bookmarked.png") {
        oriImg.attr('src', "/assets/unbookmarked.png");
    }
    else {
        oriImg.attr('src', "/assets/bookmarked.png");
    };
}

/*
// The function for toggle bookmark
function swapBookmarkImage()
{
    //$('#bookmark_star').toggleClass('fa-star fa-star-o');

    var oriI = jQuery("#bookmark_star i");
    var oriMsg = jQuery("#bookmark_star span");
    //oriI.toggleClass('fa-star fa-star-o');

    // Change the image src toggle based on the current image
    if (oriI.hasClass("fa-star")) {
        oriI.removeClass("fa-star");
        oriI.addClass("fa-star-o");
        oriMsg.text("Unstarred");
    }
    else {
        oriI.removeClass("fa-star-o");
        oriI.addClass("fa-star");
        oriMsg.text("Starred");
    };
}
*/


/*
$("#container").mason({
    itemSelector: ".box",
    ratio: 1.5,
    sizes: [
        [1,1],
        [2,2]
    ]
});
*/