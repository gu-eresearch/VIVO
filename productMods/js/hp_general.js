
$(document).ready(function(){
/* show hide left "find a" search box */
	$("#intro-lft-search-nav li").click(function(){
		$("#intro-lft-search-nav li").each(function(){
			if ($(this).find(".active")){
				$(this).removeClass("active");
				var childNum = $(this).index();
				if ($("#intro-left-search-container div:eq("+childNum+")").css("display") == "block") {
					$("#intro-left-search-container div:eq("+childNum+")").hide();
				} 
			}
		})
		var searchNum = $(this).index();
		$("#intro-left-search-container div:eq("+searchNum+")").show();
		$(this).addClass("active");
		
		
	});
	
	
})

/* lft-intro search box form submit scripts */

function submit_keyword_form(){
	var path = postVars("intro-left-tsearch-input", site_url+"/search?querytext=");
}

function submit_researcher_form(){
	var path = postVars("intro-left-rsearch-input", site_url+"/search?querytext=", "&submit=Search#fq={!tag=classgroup}classgroup%3A%22vitroClassGroupresearchers%22"); 
}



function postVars(input_id, def_path, def_path_sec2){
		var inputval = $.trim($('#'+input_id).val());
		if(inputval.length > 0) {
		
			if (def_path_sec2){
				
				var path = def_path+($('#'+input_id).val())+def_path_sec2;
				$('#'+input_id).val("");
			} else {
				
				var path = def_path+($('#'+input_id).val());
				$('#'+input_id).val("");
			}
	
			window.location = path;
		}

	};
