// removes empty pagination binding box



$(window).load(function(){
	if ($('#pagination ul li').length == 0){
		$('#pagination').hide();
	}
});
