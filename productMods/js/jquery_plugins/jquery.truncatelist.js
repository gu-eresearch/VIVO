// JavaScript Document
(function($) {
$.fn.truncatelist = function(trunc_num){
	var ind_fix = trunc_num-1;
	var height =  $(this).height();
	var el_left = 0;	
		
		$(this).each(function(){
			el_left = 0;
			var max_el = $(this, 'li').children().length;
			el_left = max_el - trunc_num;
			$('li:gt('+ind_fix+')', this).addClass('truncated');
			$('li:gt('+ind_fix+')', this).hide();
			if (max_el > trunc_num) {
				$(this, ':last').append('<li><a href="javascript:void(0);" class="tr_more">'+el_left+' more...</a></li>');
			}
		});
		
		$('.tr_more').toggle(function(){

			$(this).closest('li').siblings().show();
			$(this).attr('class', 'tr_less').text("less...");

				
		}, function(){
		
			//els_remain();
			var cl_ul = $(this).closest('ul');
			var els_left = $(this).closest('ul').children('.truncated').length;	

			$(this).closest('ul').children('li:gt('+ind_fix+'):not(:last)').hide();
			$(this).attr('class', 'tr_less').text(els_left+" more...");

		})
		
}

	
})(jQuery);