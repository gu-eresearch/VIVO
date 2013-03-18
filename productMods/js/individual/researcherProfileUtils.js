

$(document).ready(function(){

//LEFT TAB MENU ON 'BACKGROUND' SECTION OF PROFILE PAGES
	
		//Apply active state to first tab/button
		$('#background-properties article').children("h3:first").addClass('active');
		$('#background-properties article').children("ul:first").css('display', 'inline-block');
		
		//Add click function
		$('.background_property').click(function() {
			
			 //Hide all content blocks
			 $('.propertyList_background').css('display', 'none');
			 
			 //Find adjacent content block, display it
		   $(this).next('ul').css('display', 'inline-block');
		   
		   //Make content window the correct height
		   var windowHeight = $(this).next('ul').height() + 40 + 'px';
		   $('#background-properties').css('height', windowHeight ); 
		   
		   //Remove active state from all tab/buttons
		   $('.background_property').removeClass('active');
		   
		   //Apply active state to clicked tab/button
		   $(this).addClass('active');
		});
		
//END TABBED MENU
		
});
