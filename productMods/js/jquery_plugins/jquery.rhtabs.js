(function($) {


    $.fn.rhtabs = function(tab_id, nav_id) {
	
	var hashval = location.hash.substring(1, location.hash.length);
	
	//console.log(hashval.substring(1, hashval.length));
	hide_el(tab_id);
	//add_ids(nav_id);
	var navtabs_Array = new Array();
	var val = 'overview';
	function hide_el(id){
		var op = check_op(id);
		
		var i = 0;
		if(id){
			$(op+id).each(function(){
				
				var val = $.trim($(this).find('h2').text()).toLowerCase();
				
				i = i+1;

				if(typeof hashval !== "undefined" && hashval){
					if(val != hashval){

						$(this).hide();
					} else {
						$('#'+nav_id+' li:nth-child('+i+')').attr('id', 'profiles-tab-active');
						
					}
				} else {
					if(i > 1){
						$(this).hide();
					} else {
						$('#'+nav_id+' li:nth-child('+i+')').attr('id', 'profiles-tab-active');
					}	
				}
			});
		}
	};
	// check to see if element is id or class fix for research Hub
	function check_op(id){
		var op = '';
		if ($('.'+id).length){
			op = '.';
		} else {
			op = '#';
		}
		return op;
	}
	// add this function if you want to add ids to nav elements
/*	function add_ids(id){
		//console.log($('#'+id).find('li').text());
		//var new_id = $('#'+id).find('li').text();
		$('#'+id).find('li').each(function(){
			var new_id = $(this).text();
			$(this).attr('id',new_id)
			console.log($(this).text());

			});
			
	}*/
	// bind a click function
	$('#'+nav_id+' li').bind('click', function(){
	
			var but_loc = $('#'+nav_id+' li').index(this);
			var i = 0;
			
			$('.'+tab_id).each(function(){
				var pre_i = i+1;
				if(i == but_loc){
					$(this).show();
					$('#'+nav_id+' li:nth-child('+pre_i+')').attr('id', 'profiles-tab-active');

				} else {
					$(this).hide();
					$('#'+nav_id+' li:nth-child('+pre_i+')').attr('id', '')
				}
				i = i+1;
			});
	});
	

	
	

	};
})(jQuery);