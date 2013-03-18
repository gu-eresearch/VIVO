$(document).ready(function() {   

//Show and hide contextual help menu on edit interface pages
     
     //construct variable cookie name, relative to the title of the page content
     var page = $('#edit-interface-wrapper').children('h2').text().replace(/ /g,'');
     var page = page + '_hide_help';
     
     //Check to see if cookie exists. Default is to display help. If cookie is true this will hide it.
     if($.cookie(''+page+'') == 'true'){
        $('a.show_help').css('display', 'block');
        $("div.message").css('display', 'none');      
     };
     
     //Hide help box, display link to re-open help box
     $('a.close_box').click(function() {
		$('a.show_help').show(400);
        $('a.show_help').css('display', 'block');
        $(this).parents("div.message").fadeOut(500);
        //Set cookie preference to hide help display
        $.cookie(''+page+'', 'true', { expires: 60, path: page });
		return false;
	 });
     
     //Show help box, hide link to re-open as it is no longer needed
     $('a.show_help').click(function() {
        $('a.show_help').css('display', 'none');
        $("div.message").fadeIn(500);
        //Set cookie preference to show help display
        $.cookie(''+page+'', 'false', { expires: 60, path: page });
        return false;
     });
     

}); 
