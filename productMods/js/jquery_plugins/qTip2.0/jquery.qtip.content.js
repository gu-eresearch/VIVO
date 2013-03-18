$(document).ready(function() {

	// IMPORTANT - DO NOT REFERENCE THE CLASS 'TOOLTIP', THE VIVO TEMPLATE USES IT FOR OTHER PURPOSES

	//
	//
	//  TOOLTIP CONTENT
	//  Initialisation and configuration below
	//
	//

	// Add tooltip class to main nav
	$('#main-nav').find('li').find('a').each(function(){
		$(this).addClass('tips');
	});
	
	//Add title tags to main nav
	$('#main-nav').find('li').find('a').each(function(){
		if ( $(this).attr('data-link') == 'Home' ) {
			$(this).attr("title", "Visit the Research Hub Home Page");
		} else if ( $(this).attr('data-link') == 'Researchers' ) { 
			$(this).attr("title", "Search for Researchers");
		} else if ( $(this).attr('data-link') == 'Groups' ) { 
			$(this).attr("title", "Search for Groups");
		} else if ( $(this).attr('data-link') == 'Projects' ) { 
			$(this).attr("title", "Search for Projects");
		} else if ( $(this).attr('data-link') == 'Publications' ) { 
			$(this).attr("title", "Search for Publications");
		} else if ( $(this).attr('data-link') == 'Collections' ) { 
			$(this).attr("title", "Search for Collections");
		} else if ( $(this).attr('data-link') == 'Services' ) { 
			$(this).attr("title", "Search for Services");
		} else if ( $(this).attr('data-link') == 'About' ) { 
			$(this).attr("title", "About the Research Hub");
		} else if ( $(this).attr('data-link') == 'Help' ) { 
			$(this).attr("title", "Frequently Asked Questions and Quick Start Guides");
		} else if ( $(this).attr('data-link') == 'Contact' ) { 
			$(this).attr("title", "Contact Research Hub System Admins");
		}
		
	});
	
	//Find profile property menu, apply a dataset for initialization to catch and display.
	$('#property-group-menu ul li').find('a').each(function(){
		if ($(this).text() == 'Overview') {
			$(this).attr('data-tooltip', 'This tab provides an overview of you and your research areas.');
		}
	});
	
	
	//Profile page overview panel tooltips

    if ( $('#hasMemberRole_heading') ) {
        $('#hasMemberRole_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="This lists the Research Centre(s) at Griffith University that you are a member of." />');
    }
    if ( $('#overview_heading') ) {
        $('#overview_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="This is a brief general overview statement about you e.g. your current role, background, goals and achievements." />');
    }
    if ( $('#researchOverview_heading') ) {
        $('#researchOverview_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="This is a brief overview statement specifically about your research e.g. your areas of research, goals and achievements." />');
    }
    if ( $('#hasSubjectArea_heading') ) {
        $('#hasSubjectArea_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="This is a listing of the ANZSRC Field of Research codes that have been assigned to your publications." />');
    }
    if ( $('#hasResearchArea_heading') ) {
        $('#hasResearchArea_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="This is a listing of free text keywords that further define your research areas." />');
    }
    if ( $('#hasMediaKeyword_heading') ) {
        $('#hasMediaKeyword_heading').append('<img class="tooltipIcon" src="/images/infoIcon.png" alt="tooltip" data-tooltip="These are keywords created by External Relations. They are not visible on your public profile." />');
    }
		
		
		
	
	
	//
	//
	//  TOOLTIP INITIALISATION
	//  Content and title attributes targeted and defined above
	//
	//
	
	
	//Class initialization for jquery Qtip tooltip plugin, automatically references title tag unless content is otherwise supplied.
	$('.tips').qtip({
		position: {
			my: 'bottom left',  // Position my top left...
			at: 'top right', // at the bottom right of...
			//target: $('.tips'), // my target
			//viewport: $(window), // Keep it on-screen at all times if possible
			adjust: {
				x: -5,  y: 3
			}
		},
		style: {
			classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
		}
	});
	
	//HTML5 Dataset initialisation, will grab any element with a data-tooltip attribute that isnt blank.
	$('[data-tooltip!=""]').qtip({ // Grab all elements with a non-blank data-tooltip attr.
		content: {
			attr: 'data-tooltip' // Tell qTip2 to look inside this attr for it's content
		},
		position: {
			my: 'bottom left',  // Position my top left...
			at: 'top right', // at the bottom right of...
			adjust: {
				x: -5,  y: 3
			}
		},
		style: {
			classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
		}
	});
	
	//HTML5 Dataset initialisation, will grab any element with a data-tooltip attribute that isnt blank.
	//Slightly different to above, adds offset for profile page subtitles.
	$('h3.overview_property[data-tooltip!=""]').qtip({ // Grab all elements with a non-blank data-tooltip attr.
		content: {
			attr: 'data-tooltip', // Tell qTip2 to look inside this attr for it's content
		},
		position: {
			my: 'bottom center',  // Position my top left...
			at: 'top center', // at the bottom right of...
			adjust: {
				x: 0,  y: 3
			}
		},
		style: {
			classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
		}
	});
	
	//Permanent on-ready initialisation - these tooltips will be appear on load and wont disappear until the 'x' button is clicked.
	//$('#first-time-login').find('[data-tooltip!=""]').qtip({ // Grab all elements with a non-blank data-tooltip attr.
	//	content: {
	//		attr: 'data-tooltip', // Tell qTip2 to look inside this attr for it's content
	//		title: {
	//			text: ' ',
	//			button: true
	//		}
	//	},
	//	show: {
	//		ready: true
	//	},
	//	hide: {
	//		event: false
	//	},
	//	position: {
	//		my: 'bottom center',  // Position my top left...
	//		at: 'top center', // at the bottom right of...
	//		adjust: {
	//			x: 0,  y: 3
	//		}
	//	},
	//	style: {
	//		classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
	//	}
	//});
	
	//Permanent toggle initialisation - these tooltips will be appear when a button is clicked and wont until a user hovers them.
	$('#display-tooltips').mouseenter(function(){
		$('[data-tooltip!=""]').qtip({ // Grab all elements with a non-blank data-tooltip attr.
			content: {
				attr: 'data-tooltip', // Tell qTip2 to look inside this attr for it's content
			},
			show: {
				target: $('#display-tooltips'),
				event: 'click'
			},
			hide: {
				event: 'unfocus'
			},
			position: {
				my: 'bottom left',  // Position my top left...
				at: 'top right', // at the bottom right of...
				adjust: {
					x: -5,  y: 3
				}
			},
			style: {
				classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
			}
		});
	});
	$('h3.overview_property').hover(function(){
		$('[data-tooltip!=""]').qtip({ // Grab all elements with a non-blank data-tooltip attr.
			content: {
				attr: 'data-tooltip' // Tell qTip2 to look inside this attr for it's content
			},
			position: {
				my: 'bottom left',  // Position my top left...
				at: 'top right', // at the bottom right of...
				adjust: {
					x: -5,  y: 3
				}
			},
			style: {
				classes: 'ui-tooltip-shadow-two ui-tooltip-trans-black'
			}
		});
	});
});

	
