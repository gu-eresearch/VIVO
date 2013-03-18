
(function($) {
$.fn.addhelptooltip = function(tooltip_array, searchByTitleWord){

	/* check to see if search by titleWord has been used*/
	if (searchByTitleWord != false){
		get_item_byClass(tooltip_array, searchByTitleWord);
	} else {
		
		get_item(tooltip_array);
	}
	
	function get_item (tooltip_array){
		$.each(tooltip_array, function(key, value){
			$("#"+key).wrap('<div class="property-header" />');
			img_object = '<img border="0" class="property-sub-title-img" alt="help information button" title="'+value+'" src="'+site_url+'/themes/gu/images/info_icon.png" />';
			$(img_object).insertAfter($("#"+key));

		});
		
	};
	/* this assumes that all class names given will be <h3> that are not a heading like publications*/
	function get_item_byClass (tooltip_array, searchByTitleWord){
		$.each(tooltip_array, function(key, value){
			$("."+key+" h3:contains("+searchByTitleWord+")").wrap('<span class="property-sub-header" />');
			$("."+key+" h3:contains("+searchByTitleWord+")").attr('class', 'property-sub-title');
			img_object = '<img border="0" class="property-sub-title-img" alt="help information button" title="'+value+'" src="'+site_url+'/themes/gu/images/info_icon.png" />';
			$(img_object).insertAfter($("."+key+" h3:contains("+searchByTitleWord+")"));
		});
	}

}

})(jQuery);
	
	

	

