var allLoaded = false;
var rssItems = [];

$(document).ready(function() {
// set vars
var numberOfWords = 15;




// get rss feed from jsp proxy
$.ajax({  
    type: "GET",  
    url: rss_proxy_url,  
    dataType: "xml",  
    success: parseXml2  
}); 


// process rss feed xml
function parseXml2(xml) { 
	var key = 0;
	var html = '';
	 //find the rss item in the rss feed
	// $(".rss-wrapper").append('<ul class="ul-rss-wrapper"></ul>')
    $(xml).find("item").each(function() {  
		//declare rss variable
		if (key < 1000) {
			var rss_id = $(this).find("guid").text();
			var title = $(this).find("title").text();
			var date = $(this).find("date").text();
			var desc = trimByWord($(this).find("description").text());

			var link = $(this).find("link").text();
			var pubDate = $(this).find("pubDate").text().slice(0, -15);
			
			
			html += '<li class="entry'+key+'">';
			html += '<a class="rss-a'+key+'" href="'+link+'" target="_blank">';
			//html += '<div class="rss_img"><img src="http://research-hub-dev.griffith.edu.au/rss_cache/'+rss_id+'.jpg" alt="'+title+'"/></div>';
			//html += '<div class="rss_img"><img src="http://www3.griffith.edu.au/03/ertiki/article_image.php?id='+rss_id+'" alt="'+title+'"/></div>';
			html += '<span class="rss_title">'+title+'</span>';
			html += '<span class="rss_date">'+pubDate+'</span><br/>';
			html += '<div class="rss_desc"><span>'+desc+'</span></div>';
			html += '</a></li>';
			
			/*			
			html += '<a class="rss-a'+key+'" href="http://www3.griffith.edu.au/03/ertiki/tiki-read_article.php?articleId='+rss_id+'" target="_blank">';
			html += '<div class="rss_img"><img src="http://research-hub-dev.griffith.edu.au/rss_cache/'+rss_id+'.jpg" alt="'+title+'"/></div>';
			html += '<span class="rss_title">'+title+'</span>';
			html += '<div class="rss_desc"><span>'+desc+'</span></div>';
			html += '</a>';
			
			rssItems.push(html);
			*/
			
		}
		key++;	
		
	
     }); 
     
     $('.ul-rss-wrapper').html(html);	
     
     $(".rss-wrapper").scrollable({ 
			circular: true, 
     		vertical:true

     		}).autoscroll({ 
     			autoplay: true,
     			interval: 6000
     			});	
    /*
     var root = $(".rss-wrapper").scrollable({
     		circular: true, 
     		vertical:true,
     		items: '.ul-rss-wrapper'
     		}).autoscroll({ 
     			autoplay: true,
     			interval: 200
     			});
	// provide scrollable API for the action buttons
	window.api = root.data("scrollable");
*/
	 /*
	$(".ul-rss-wrapper").jcarousel({
		auto: 1,
		vertical: true,
		scroll: 1,
		wrap: 'circular',
		itemLoadCallback: {onBeforeAnimation: mycarousel_itemLoadCallback}
	});
	*/
	 
}




// truncate description text if over numberOfWords set in var up top

function trimByWord(str_data) {
    var result = str_data;
    var resultArray = result.split(" ");
    if(resultArray.length > numberOfWords){
    resultArray = resultArray.slice(0, numberOfWords);
    result = resultArray.join(" ") + " ... read more";
    } else {
	result = resultArray.join(" ") + " ... read more";	
	}
    return result;
}

// make pretty rotation




});



