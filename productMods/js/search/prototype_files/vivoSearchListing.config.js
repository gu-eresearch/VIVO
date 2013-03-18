// Variables out here are available throughout the application
var Manager;






// The "Show all" popups for facets are a separate type of widget. Functionally they are very similar
// to the facet widgets, but they retrieve unlimited numbers of facet items from Solr. Because this can
// severely impact the app's performance, these widgets are not loaded by default. Instead they get
// attached to the Manager dynamically.

// *** Internal IDs for popups should be the same as the facet, with "_popup" appended ***
var popups = {};
var groups = {
 'vitroClassGroupresearchers' : { 'name': 'Researchers', 'value': 'vitroClassGroupresearchers' },
 'vitroClassGroupgroups' : { 'name': 'Groups', 'value': 'vitroClassGroupgroups' },
 'vitroClassGroupprojects' : { 'name': 'Projects', 'value': 'vitroClassGroupprojects' },
 'vitroClassGrouppublications' : { 'name': 'Publications', 'value': 'vitroClassGrouppublications' },
 'vitroClassGroupcollections' : { 'name': 'Collections', 'value': 'vitroClassGroupcollections' },
 'vitroClassGroupservices' : { 'name': 'Services', 'value': 'vitroClassGroupservices' }
};

// Variable that represents the current search scope
var nationalSearch = false;


var prototypeURL = 'http://research-hub.griffith.edu.au';

(function ($) {

  $(function () {
  
  
  Manager = new AjaxSolr.Manager({
    solrUrl: solrServerUrl,
    servlet: 'select'
  });

  Manager.setStore(new AjaxSolr.ParameterHashStore());
	

  Manager.store.exposed = ['fq','q','start'];
 
 

  var params = {
    'facet': true,
    'fl': [	'dp_name',
			'URI',
			'op_context_hasPrimaryAffiliationRole',
			'op_context_hasMemberRole',
			'op_label_hasSubjectArea',
			'op_label_hasResearchArea',
			'dp_preferredTitle',
			'op_authorInAuthorship',
			'op_context_hasInvestigatorRole',
			'op_context_hasPrincipalInvestigatorRole',
			'dp_issued',
			'op_label_informationResourceInAuthorship',
			'dp_chapter',
			'dp_isbn',
			'dp_issn',
			'dp_volume',
			'dp_pageStart',
			'dp_pageEnd',
			'dp_book_journal_name',
			'op_context_memberRoleOf',
			'op_context_primaryAffiliationRoleOf',
			'op_context_startYear',
			'dp_context_startYear_sort',
			'op_context_endYear',
			'dp_context_endYear_sort',
			'op_context_linkedAuthor',
			'op_context_allResearchAreas',
			'dp_familyName',
			'dp_givenName',
			'dp_label',
			'op_label_relatedProject',
			'op_label_relatedRole',
      'op_context_projectLabel',
			'dp_preferredName'],
    'facet.limit': 5,
    'facet.mincount': 1,
    'f.classgroup.facet.limit': 20,
    'facet.field': '{!ex=type,classgroup,research_areas}type',
    'f.type.facet.limit': 1,
    //'fq=-PROHIBITED_FROM_TEXT_RESULTS:1': 1,
    'hl': true,
    'hl.snippets': 2,
    'hl.fl': 'ALLTEXT',
    'hl.fragsize': 120,
    'rows': 10,
    'json.nl': 'map'
    
  };
  for (var name in params) {
    Manager.store.addByValue(name, params[name]);
  };
  
  	

	
   
 		
 	

  // Search form(s)
  Manager.addWidget(new AjaxSolr.SearchText({
    id: 'search',
    target: '#search-form'
  }));

  // Results area
  Manager.addWidget(new AjaxSolr.ResultWidget({
    id: 'results',
    target: '#results'
  }));
  
  	Manager.addWidget(new AjaxSolr.SortWidget({
	  id: 'sort',
	  target: '#sort-widget',
	  field: 'date'
	}));

  // Pagination
  Manager.addWidget(new AjaxSolr.PagerWidget({
    id: 'pager',
    target: '#pager',
    prevLabel: '&laquo; PREV',
    nextLabel: 'NEXT &raquo;',
    innerWindow: 1,
    renderHeader: function (perPage, offset, total) {
      var resultType = ' results';
      // Determine which type of results we're trying to show (people, organizations, etc.)
      if (this.manager.store.findByKey('fq', 'classgroup')) {
        var group = this.manager.store.params['fq'][0];
        if (group.value !== undefined) {
			  if (groups[group.value] !== undefined) {
				resultType = groups[group.value].name.toLowerCase();
			  } 
		  } else {
				if (groups[0] !== undefined) {
				resultType = groups[0].name.toLowerCase();
			  } 
		  }
      }
      // Update the element that holds result counts
      if (this.manager.response.response.numFound > 0) {
        $('#results-header').html($('<span/>').text(Math.min(total, offset + 1) + ' – ' + Math.min(total, offset + perPage) + ' of ' + total + ' ' + resultType));
      }
    },
    beforeRequest: function() {
      // $('#results-header').empty();
      $(this.target).empty();
    }
  }));

  // Classgroup menu
  Manager.addWidget(new AjaxSolr.GroupFacet({
    id: 'classgroup',
    target: '#search-categories',
    field: 'classgroup',
    exclude: ['type'],
    groups: groups,
    tagAndExclude: true,
    allowMultipleValues: false
  }));
  
  Manager.addWidget(new AjaxSolr.CurrentSearchWidget({
	  id: 'currentsearch',
	  target: '#selection-breadcrumbs'
	}));

	//Free text widget
	Manager.addWidget(new AjaxSolr.TextWidget({
	  id: 'free-text',
	  target: '#free-text-filter',
	  title: 'Keywords',
	  field: 'ALLTEXT'
	}));

  
  // Facet: "Type"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'type',
    target: '#search-facet-1',
    field: 'op_context_mostSpecificTypeLabel',
    title: 'Type',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  
  popups.type = new AjaxSolr.MultiCheckboxPopup({
    id: 'type_popup',
    target: '#search-facet-1-popup',
    field: 'op_context_mostSpecificTypeLabel',
    title: 'Type',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
   // Facet: "Research areas"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'research_areas',
    target: '#search-facet-4',
    field: ['op_context_allResearchAreas'],
    title: 'Research Areas and Keywords',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.research_areas = new AjaxSolr.MultiCheckboxPopup({
    id: 'research_areas_popup',
    target: '#search-facet-4-popup',
    field: ['op_context_allResearchAreas'],
    title: 'Research keywords',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  /*
   // Facet: "Subject areas"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'subject_areas',
    target: '#search-facet-5',
    field: ['op_label_hasSubjectArea'],
    title: 'Research areas',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5,
    defaultQuery: "Education Systems"
  }));
  popups.subject_areas = new AjaxSolr.MultiCheckboxPopup({
    id: 'subject_areas_popup',
    target: '#search-facet-5-popup',
    field: ['op_label_hasSubjectArea'],
    title: 'Research areas',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  */
  
  
  // Facet: "Publication Year"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'pub_year',
    target: '#search-facet-6',
    field: ['dp_issued'],
    title: 'Publication Year',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.pub_year = new AjaxSolr.MultiCheckboxPopup({
    id: 'pub_year_popup',
    target: '#search-facet-6-popup',
    field: ['dp_issued'],
    title: 'Publication Year',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  
   
  // Facet: "Project Year"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'project_year',
    target: '#search-facet-7',
    field: ['op_context_projectActiveYear'],
    title: 'Project Year',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.project_year = new AjaxSolr.MultiCheckboxPopup({
    id: 'project_year_popup',
    target: '#search-facet-7-popup',
    field: ['op_context_projectActiveYear'],
    title: 'Project Year',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  
   // Facet: "Project Status"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'project_status',
    target: '#search-facet-8',
    field: ['op_label_projectstate'],
    title: 'Project Status',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.project_status = new AjaxSolr.MultiCheckboxPopup({
    id: 'project_status_popup',
    target: '#search-facet-8-popup',
    field: ['op_label_projectstate'],
    title: 'Project Status',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  
  
   // Facet: "Project Funded by"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'project_fundedby',
    target: '#search-facet-9',
    field: ['op_label_fundedBy'],
    title: 'Funded By',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  
  popups.project_fundedby = new AjaxSolr.MultiCheckboxPopup({
    id: 'project_fundedby_popup',
    target: '#search-facet-9-popup',
    field: ['op_label_fundedBy'],
    title: 'Funded By',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  /*
  
   // Facet: "Avaliable for supervision"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'availableForSupervision',
    target: '#search-facet-10',
    field: ['availableForSupervision'],
    title: 'Available For Supervision',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.availableForSupervision = new AjaxSolr.MultiCheckboxPopup({
    id: 'availableForSupervision_popup',
    target: '#search-facet-10-popup',
    field: ['availableForSupervision'],
    title: 'Available For Supervision',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  */
  
  
   // Facet: "Published In"
  Manager.addWidget(new AjaxSolr.MultiCheckboxFacet({
    id: 'dp_book_journal_name',
    target: '#search-facet-11',
    field: ['dp_book_journal_name'],
    title: 'Published In',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 5
  }));
  popups.dp_book_journal_name = new AjaxSolr.MultiCheckboxPopup({
    id: 'dp_book_journal_name_popup',
    target: '#search-facet-11-popup',
    field: ['dp_book_journal_name'],
    title: 'Published In',
    tagAndExclude: true,
    allowMultipleValues: true,
    limit: 9999
  });
  
  
  
  Manager.init();
  
    var filterParam = $.getURLParam('pfq');

	if (filterParam) {
		filterParam = decodeURI(filterParam);
		var containsHash = filterParam.indexOf('#');
		if (containsHash > 0) {
			filterParam = filterParam.substring(0,containsHash);
		}
		var filterKey = ['op_label_hasSubjectArea'];
		if (listingPageFor == 'groups') {
			filterKey = ['type'];
		}
		var param = new AjaxSolr.Parameter({
			name: 'fq',
			key: filterKey,
			value: filterParam,
			filterType: 'subquery',
			operator: 'OR'
		  });
		  param.local('tag', 'subject_areas'); 
		  Manager.store.add('fq',param);
	}

  
  
  var value = Manager.store.get('q').val();
  if(!value) {
  	//Manager.store.addByValue('q',' ');
  }
  
	selectedClassGroup = 'vitroClassGroupresearchers';
	selectedSortString = 'dp_nameLowercaseSingleValued+asc';
	selectedSortOption = 'alpha_asc';
	  if (listingPageFor) {
		if (listingPageFor == 'researchers') {
			selectedClassGroup = 'vitroClassGroupresearchers';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		} else if (listingPageFor == 'projects') {
			selectedClassGroup = 'vitroClassGroupprojects';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		} else if (listingPageFor == 'groups') {
			selectedClassGroup = 'vitroClassGroupgroups';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		} else if (listingPageFor == 'publications') {
			selectedClassGroup = 'vitroClassGrouppublications';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		} else if (listingPageFor == 'collections') {
			selectedClassGroup = 'vitroClassGroupcollections';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		} else if (listingPageFor == 'services') {
			selectedClassGroup = 'vitroClassGroupservices';
			selectedSortString = 'dp_nameLowercaseSingleValued+asc';
			selectedSortOption = 'alpha_asc';
		}
	  }
	  
	  
	 var sortSelectOptions = '<option value="rel">Best Match</option>'+
								'<option value="date_new">Date (Newest first)</option>'+
								'<option value="date_old">Date (Oldest first)</option>'+
								'<option value="alpha_asc">Alphabetical (ascending)</option>'+
								'<option value="alpha_desc">Alphabetical (descending)</option>';
 
	 if (listingPageFor == 'researchers' || listingPageFor == 'groups' ) {
		sortSelectOptions = '<option value="rel">Best Match</option>'+
							'<option value="alpha_asc">Alphabetical (ascending)</option>'+
							'<option value="alpha_desc">Alphabetical (descending)</option>';
	 }
      
     $('#sort-select').html(sortSelectOptions);
	  

	
	  
    //Set default group on load of page
	var param = new AjaxSolr.Parameter({
      name: 'fq',
      key: 'classgroup',
      value: selectedClassGroup
    });
    param.local('tag', 'classgroup');
    Manager.store.add('fq',param);
    
    //set default sort for results  
    var sortvalue = Manager.store.get('sort').val();
	if(!sortvalue) {
		Manager.store.addByValue('sort',selectedSortString);
		$("#sort-select option[selected]").removeAttr("selected");
		$("#sort-select option[value='"+selectedSortOption+"']").attr("selected", "selected"); 
	  }
  
  
  
  //Manager.widgets['classgroup'].init();
  // Run a search after the page loads
  Manager.doRequest(0);

  });
})(jQuery);
