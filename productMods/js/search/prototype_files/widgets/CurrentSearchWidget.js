(function ($) {
	
AjaxSolr.CurrentSearchWidget = AjaxSolr.AbstractWidget.extend({
  afterRequest: function () {
    var self = this;
    var links = [];

    var fq = this.manager.store.values2('fq');
    var q = this.manager.store.values2('q');
    var filterCount = 0;
    
    //console.log(fq);
    //console.log(q);
    
    
    links.push($('<span class="facet-title facet-wrapper">').html('Keywords'));
	
	$(q).each(function(i, item){

		//console.log(item.length) ;
		if (!(item == null)  ) {
			if (item.length > 1) {
				links.push($('<a href="#"/>').html('<span class="facet-wrapper"><span class="facet-type">' + item + '</span><span class="remove-facet">(x)</span></span>').click(self.removeFacet(item)));
				filterCount++;
			}
		}	
	});

    
    for (var i = 0, l = fq.length; i < l; i++) {
      if (fq[i].match(/[\[\{]\S+ TO \S+[\]\}]/)) {
        var field = fq[i].match(/^\w+:/)[0];
        var value = fq[i].substr(field.length + 1, 10);
        field = '';
        links.push($('<a href="#"/>').html('(x) ' + field + value).click(self.removeFacet(fq[i])));
		
      }
      else {
      	var field = fq[i].match(/^\w+:/)[0];
        var value = fq[i].substr(field.length + 1, 10);
        
        //fq[i].substring(fq[i].indexOf('vitroClassGroup')+15,fq[i].length)
        //console.log(fq[i].substring(fq[i].indexOf('vitroClassGroup')+15,fq[i].length));
        //console.log(fq[i]);
        var pos = fq[i].indexOf("vitroClassGroup");
        if (pos>-1) {
        	links.push($('<a href="#"/>').html('<span class="facet-wrapper"><span class="facet-type">' + fq[i].substring(pos+15,fq[i].length) + '</span><span class="remove-facet">(x)</span></span>').click(self.removeFacet(fq[i])));
        	filterCount++;
        } else {
			var pos = fq[i].lastIndexOf(":")+1;
			links.push($('<a href="#"/>').html('<span class="facet-wrapper"><span class="facet-type">' + fq[i].substring(pos,fq[i].length) + '</span><span class="remove-facet">(x)</span></span>').click(self.removeFacet(fq[i])));
			filterCount++;
        }
        
        
        
      }
    }
    
    if (filterCount == 0) {
    	links.push($('<a href="#"/>').html('<span class="facet-wrapper"><span class="facet-type">No Keywords or filters selected</span></span>'));
    }

    if (links.length > 2) {
      links.push($('<a href="#"/>').html('<span class="remove-facet">remove all</span>').click(function () {
        self.manager.store.remove('fq');
        self.manager.store.remove('q');
        self.manager.doRequest(0);
        return false;
      }));
    }

    if (links.length) {
      AjaxSolr.theme('list_items', this.target, links);
      $('.facet-type').truncate({max_length: 100, display_number:1}); 
    }
    else {
      $(this.target).html('<div> none</div>');
    }
  },

  removeFacet: function (facet) {
    var self = this;
    return function () {
      if (self.manager.store.removeByValue('fq', facet)) {
        self.manager.doRequest(0);
      } 
      
      if (self.manager.store.removeByValue('q', facet)) {
        self.manager.doRequest(0);
      }
      
      
      return false;
    };
  }
});

})(jQuery);
