// jquery plugin to add selector icon to primary nav

(function($) {


    $.fn.setnav = function(bcrumb_id, nav_id) {
	
	
	function searchbtns(val){
		$('#'+nav_id).find().each(function(){
	
		if ($(this).text() == val){
			$(this).prepend('<span class="selected-main-nav"></span>');
			//$(this).children().addClass("primnav_selected");	
		} else {
			$(this).find('.selected-main-nav').remove();
		}
		
		})
	}
	
	function get_crumb(crumb_id){
		var val = $("#"+crumb_id+" li:nth-child(2) a").text();
		//$("ul li:nth-child(2)").append("<span> - 2nd!</span>");
		//console.log($("#"+crumb_id+" li:nth-child(2) a").text());
		return val;
	}
	
	var val = get_crumb(bcrumb_id);	
	//console.log(val);
	searchbtns(val)

	};
	
	})(jQuery);