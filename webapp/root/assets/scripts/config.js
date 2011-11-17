/*

	Config.js: main javascript file

*/

$(document).ready( function() {

	/* modules */
	
	/* link behaviours */
	$("a.ctrl.tooltip").tooltip({
		position: "bottom right",
		predelay: 30,
		delay: 50,
		effect: "fade",
		fadeInSpeed: 400,
		fadeOutSpeed: 400,
		tipClass: "tooltipBox"
	});	
	
	if ( $.fancybox ) {
		$(".ctrl.overlayTrigger").fancybox();
	};
	
	/* tabs */
	$(".mod.tabs").tabs(".tabPanes > section");
	
});