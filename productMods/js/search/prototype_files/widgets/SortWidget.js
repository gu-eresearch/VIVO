(function ($) {
// For a TextWidget that uses the q parameter, see:
AjaxSolr.SortWidget = AjaxSolr.AbstractFacetWidget.extend({
  init: function () {
    var self = this;
    var selectBox = $(this.target).find('select');
    selectBox.bind('change', function(e) {
    	var sortValue = selectBox.val();
    	var sortString = '';
    	if (sortValue == "rel") {
    		sortString = 'score+desc';
    	} else if (sortValue == "alpha_desc") {
    		sortString = 'dp_nameLowercaseSingleValued+desc';
    	} else if (sortValue == "alpha_asc") {
    		sortString = 'dp_nameLowercaseSingleValued+asc';
    	} else if (sortValue == "date_new") {
    		sortString = 'dp_context_endYear_sort+desc';
    	} else if (sortValue == "date_old") {
    		sortString = 'dp_context_startYear_sort+asc';
    	}
      
    
      self.manager.store.addByValue('sort',sortString);
      self.manager.doRequest(0);
    });
  },

  afterRequest: function () {
    //$(this.target).find('select').val('');
  }
});

})(jQuery);





