/**
 * @license 
 * jQuery Tools @VERSION Scrollable - New wave UI design
 * 
 * NO COPYRIGHTS OR LICENSES. DO WHAT YOU LIKE.
 * 
 * http://flowplayer.org/tools/scrollable.html
 *
 * Since: March 2008
 * Date: @DATE 
 */
(function($) { 

	// static constructs
	$.tools = $.tools || {version: '@VERSION'};
	
	$.tools.scrollable = {
		
		conf: {	
			activeClass: 'active',
			circular: false,
			clonedClass: 'cloned',
			disabledClass: 'disabled',
			easing: 'swing',
			initialIndex: 0,
			item: '> *',
			items: '.items',
			keyboard: true,
			mousewheel: false,
			next: '.next',   
			prev: '.prev', 
			size: 1,
			speed: 400,
			vertical: false,
			touch: true,
			wheelSpeed: 0
		} 
	};
					
	// get hidden element's width or height even though it's hidden
	function dim(el, key) {
		var v = parseInt(el.css(key), 10);
		if (v) { return v; }
		var s = el[0].currentStyle; 
		return s && s.width && parseInt(s.width, 10);	
	}

	function find(root, query) { 
		var el = $(query);
		return el.length < 2 ? el : root.parent().find(query);
	}
	
	var current;		
	
	// constructor
	function Scrollable(root, conf) {   
		
		// current instance
		var self = this, 
			 fire = root.add(self),
			 itemWrap = root.children(),
			 index = 0,
			 vertical = conf.vertical;
				
		if (!current) { current = self; } 
		if (itemWrap.length > 1) { itemWrap = $(conf.items, root); }
		
		
		// in this version circular not supported when size > 1
		if (conf.size > 1) { conf.circular = false; } 
		
		// methods
		$.extend(self, {
				
			getConf: function() {
				return conf;	
			},			
			
			getIndex: function() {
				return index;	
			}, 

			getSize: function() {
				return self.getItems().size();	
			},

			getNaviButtons: function() {
				return prev.add(next);	
			},
			
			getRoot: function() {
				return root;	
			},
			
			getItemWrap: function() {
				return itemWrap;	
			},
			
			getItems: function() {
				return itemWrap.find(conf.item).not("." + conf.clonedClass);	
			},
							
			move: function(offset, time) {
				return self.seekTo(index + offset, time);
			},
			
			next: function(time) {
				return self.move(conf.size, time);	
			},
			
			prev: function(time) {
				return self.move(-conf.size, time);	
			},
			
			begin: function(time) {
				return self.seekTo(0, time);	
			},
			
			end: function(time) {
				return self.seekTo(self.getSize() -1, time);	
			},	
			
			focus: function() {
				current = self;
				return self;
			},
			
			addItem: function(item) {
				item = $(item);
				
				if (!conf.circular)  {
					itemWrap.append(item);
					next.removeClass("disabled");
					
				} else {
					itemWrap.children().last().before(item);
					itemWrap.children().first().replaceWith(item.clone().addClass(conf.clonedClass)); 						
				}
				
				fire.trigger("onAddItem", [item]);
				return self;
			},
			
			
			/* all seeking functions depend on this */		
			seekTo: function(i, time, fn) {	
				
				// ensure numeric index
				if (!i.jquery) { i *= 1; }
				
				// avoid seeking from end clone to the beginning
				if (conf.circular && i === 0 && index == -1 && time !== 0) { return self; }
				
				// check that index is sane				
				if (!conf.circular && i < 0 || i > self.getSize() || i < -1) { return self; }
				
				var item = i;
			
				if (i.jquery) {
					i = self.getItems().index(i);	
					
				} else {
					item = self.getItems().eq(i);
				}  
				
				// onBeforeSeek
				var e = $.Event("onBeforeSeek"); 
				if (!fn) {
					fire.trigger(e, [i, time]);				
					if (e.isDefaultPrevented() || !item.length) { return self; }			
				}  
	
				var props = vertical ? {top: -item.position().top} : {left: -item.position().left};  
				
				index = i;
				current = self;  
				if (time === undefined) { time = conf.speed; }   
				
				itemWrap.animate(props, time, conf.easing, fn || function() { 
					fire.trigger("onSeek", [i]);		
				});	 
				
				return self; 
			}					
			
		});
				
		// callbacks	
		$.each(['onBeforeSeek', 'onSeek', 'onAddItem'], function(i, name) {
				
			// configuration
			if ($.isFunction(conf[name])) { 
				$(self).bind(name, conf[name]); 
			}
			
			self[name] = function(fn) {
				if (fn) { $(self).bind(name, fn); }
				return self;
			};
		});  
		
		// circular loop
		if (conf.circular) {
			
			var cloned1 = self.getItems().slice(-1).clone().prependTo(itemWrap),
				 cloned2 = self.getItems().eq(1).clone().appendTo(itemWrap);

			cloned1.add(cloned2).addClass(conf.clonedClass);
			
			self.onBeforeSeek(function(e, i, time) {
				
				if (e.isDefaultPrevented()) { return; }
				
				/*
					1. animate to the clone without event triggering
					2. seek to correct position with 0 speed
				*/
				if (i == -1) {
					self.seekTo(cloned1, time, function()  {
						self.end(0);		
					});          
					return e.preventDefault();
					
				} else if (i == self.getSize()) {
					self.seekTo(cloned2, time, function()  {
						self.begin(0);		
					});	
				}
				
			});

			// seek over the cloned item

			// if the scrollable is hidden the calculations for seekTo position
			// will be incorrect (eg, if the scrollable is inside an overlay).
			// ensure the elements are shown, calculate the correct position,
			// then re-hide the elements. This must be done synchronously to
			// prevent the hidden elements being shown to the user.

			// See: https://github.com/jquerytools/jquerytools/issues#issue/87

			var hidden_parents = root.parents().add(root).filter(function () {
				if ($(this).css('display') === 'none') {
					return true;
				}
			});
			if (hidden_parents.length) {
				hidden_parents.show();
				self.seekTo(0, 0, function() {});
				hidden_parents.hide();
			}
			else {
				self.seekTo(0, 0, function() {});
			}

		}
		
		// next/prev buttons
		var prev = find(root, conf.prev).click(function(e) { e.stopPropagation(); self.prev(); }),
			 next = find(root, conf.next).click(function(e) { e.stopPropagation(); self.next(); }); 
		
		if (!conf.circular) {
			self.onBeforeSeek(function(e, i) {
				setTimeout(function() {
					if (!e.isDefaultPrevented()) {
						prev.toggleClass(conf.disabledClass, i <= 0);
						next.toggleClass(conf.disabledClass, i >= self.getSize() -1);
					}
				}, 1);
			});
			
			if (!conf.initialIndex) {
				prev.addClass(conf.disabledClass);	
			}			
		}
			
		if (self.getSize() < 2) {
			prev.add(next).addClass(conf.disabledClass);	
		}
			
		// mousewheel support
		if (conf.mousewheel && $.fn.mousewheel) {
			root.mousewheel(function(e, delta)  {
				if (conf.mousewheel) {
					self.move(delta < 0 ? 1 : -1, conf.wheelSpeed || 50);
					return false;
				}
			});			
		}
		
		// touch event
		if (conf.touch) {
			var touch = {};
			
			itemWrap[0].ontouchstart = function(e) {
				var t = e.touches[0];
				touch.x = t.clientX;
				touch.y = t.clientY;
			};
			
			itemWrap[0].ontouchmove = function(e) {
				
				// only deal with one finger
				if (e.touches.length == 1 && !itemWrap.is(":animated")) {			
					var t = e.touches[0],
						 deltaX = touch.x - t.clientX,
						 deltaY = touch.y - t.clientY;
	
					self[vertical && deltaY > 0 || !vertical && deltaX > 0 ? 'next' : 'prev']();				
					e.preventDefault();
				}
			};
		}
		
		if (conf.keyboard)  {
			
			$(document).bind("keydown.scrollable", function(evt) {

				// skip certain conditions
				if (!conf.keyboard || evt.altKey || evt.ctrlKey || evt.metaKey || $(evt.target).is(":input")) { 
					return; 
				}
				
				// does this instance have focus?
				if (conf.keyboard != 'static' && current != self) { return; }
					
				var key = evt.keyCode;
			
				if (vertical && (key == 38 || key == 40)) {
					self.move(key == 38 ? -1 : 1);
					return evt.preventDefault();
				}
				
				if (!vertical && (key == 37 || key == 39)) {					
					self.move(key == 37 ? -1 : 1);
					return evt.preventDefault();
				}	  
				
			});  
		}
		
		// initial index
		if (conf.initialIndex) {
			self.seekTo(conf.initialIndex, 0, function() {});
		}
	} 

		
	// jQuery plugin implementation
	$.fn.scrollable = function(conf) { 
			
		// already constructed --> return API
		var el = this.data("scrollable");
		if (el) { return el; }		 

		conf = $.extend({}, $.tools.scrollable.conf, conf); 
		
		this.each(function() {			
			el = new Scrollable($(this), conf);
			$(this).data("scrollable", el);	
		});
		
		return conf.api ? el: this; 
		
	};
			
	
})(jQuery);
/**
 * @license 
 * jQuery Tools @VERSION / Scrollable Autoscroll
 * 
 * NO COPYRIGHTS OR LICENSES. DO WHAT YOU LIKE.
 * 
 * http://flowplayer.org/tools/scrollable/autoscroll.html
 *
 * Since: September 2009
 * Date: @DATE 
 */
(function($) {		

	var t = $.tools.scrollable; 
	
	t.autoscroll = {
		
		conf: {
			autoplay: true,
			interval: 3000,
			autopause: true
		}
	};	
	
	// jQuery plugin implementation
	$.fn.autoscroll = function(conf) { 

		if (typeof conf == 'number') {
			conf = {interval: conf};	
		}
		
		var opts = $.extend({}, t.autoscroll.conf, conf), ret;
		
		this.each(function() {		
				
			var api = $(this).data("scrollable"),
			    root = api.getRoot(),
			    // interval stuff
    			timer, stopped = false;

	    /**
      *
      *   Function to run autoscroll through event binding rather than setInterval
      *   Fixes this bug: http://flowplayer.org/tools/forum/25/72029
      */
      function scroll(){        
        timer = setTimeout(function(){
          api.next();
        }, opts.interval);
      }
			    
			if (api) { ret = api; }
			
			api.play = function() { 
				
				// do not start additional timer if already exists
				if (timer) { return; }
				
				stopped = false;
				
        root.bind('onSeek', scroll);
        scroll();
			};	

			api.pause = function() {
				timer = clearTimeout(timer);  // clear any queued items immediately
        root.unbind('onSeek', scroll);
			};
			
			// resume playing if not stopped
			api.resume = function() {
				stopped || api.play();
			};
			
			// when stopped - mouseover won't restart 
			api.stop = function() {
			  stopped = true;
				api.pause();
			};
		
			/* when mouse enters, autoscroll stops */
			if (opts.autopause) {
				root.add(api.getNaviButtons()).hover(api.pause, api.resume);
			}
			
			if (opts.autoplay) {
				api.play();				
			}

		});
		
		return opts.api ? ret : this;
		
	}; 
	
})(jQuery);		
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
