(function ($) {

// For a TextWidget that uses the q parameter, see:
// https://github.com/evolvingweb/ajax-solr/blob/gh-pages/examples/reuters/widgets/TextWidget.q.js
AjaxSolr.TextWidget = AjaxSolr.AbstractFacetWidget.extend({
  init: function () {
    var self = this;
	
	
		/* adds onclick function for btns search on homepage */
	$(this.target).find('input#query-btn-submit').bind('mousedown', function(e) { 
	//$(this.target).find('input#query-btn-submit').click(function(e) {
		
		
		var inputval = $.trim($('input#query').val());
		if(inputval.length > 0) {
		
			var value = $('input#query').val();
			
			
			var q = self.manager.store.values2('q');
			
			//if ( (q.length == 1 && q[0] == " ") || !q ) {
			if ( !q ) {
				self.manager.store.params['q'].value = value;
				//since we are setting the q parameter, we also set the sort to Best Match/best match		
				$("#sort-select").attr("value", "rel").change();
				self.manager.doRequest(0);
			} else {		
				var param = new AjaxSolr.Parameter({
				  name: 'fq',
				  key: self.field,
				  value: value
				});
				
				if (self.add.call(self, param) && value) {
					self.manager.doRequest(0);
				}
			}
			/*
			var q = self.manager.store.values('q');
			if (q.length == 1 && q[0] == " ") {
				self.manager.store.params['q'].value = value;
				//since we are setting the q parameter, we also set the sort to Best Match/best match			
				$("#sort-select").attr("value", "rel").change();
				self.manager.doRequest(0);
			} else {		
				var param = new AjaxSolr.Parameter({
				  name: 'fq',
				  key: self.field,
				  value: value
				});
				
				if (self.add.call(self, param) && value) {
					self.manager.doRequest(0);
				}
			}
			*/
		}
		
	})
	
	
	
    $(this.target).find('input#query').bind('keydown', function(e) {


      if (e.which == 13) {
      	var inputval = $.trim($(this).val());
        if(inputval.length > 0) {
        	var value = $(this).val();
			var q = self.manager.store.values2('q');
	
			//if ( (q.length == 1 && q[0] == " ") || !q ) {
			if ( !q ) {
				self.manager.store.params['q'].value = value;
				//since we are setting the q parameter, we also set the sort to Best Match/best match		
				$("#sort-select").attr("value", "rel").change();
				self.manager.doRequest(0);
			} else {		
				var param = new AjaxSolr.Parameter({
				  name: 'fq',
				  key: self.field,
				  value: value
				});
				
				if (self.add.call(self, param) && value) {
					self.manager.doRequest(0);
				}
				return false;
			}
		}
        
      }
    });
  },

  afterRequest: function () {
    var self = this;
    var active = this.getActiveFilter();
    
    
    $(this.target).find('input').val(active);
  },
  
  /**
   * Find the active freetext filter
   */
  getActiveFilter: function() {
    var self = this;
    var active = '';
    if (keys = this.manager.store.findByKey('fq', self.field)) {
      	$.each(keys, function(i, key) {
			active = self.manager.store.params['fq'][key].value;
	  	});
    }
    var active = '';
    return active;
  }
});

})(jQuery);
