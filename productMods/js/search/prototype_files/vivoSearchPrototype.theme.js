(function ($) {

/**
 * Theme a single category link, wrap in a list item
 *
 * @param {String} name Category name
 * @param {Integer} count Count of results associated with category
 * @param {Boolean} checked Whether or not the category is active
 * @param {Function} handler Click handler to bind to link
 */
AjaxSolr.theme.prototype.category_link = function (name, count, active, handler) {
  var cssClasses = (active == true) ? 'active' : '';
  cssClasses += (count == 0) ? ' empty' : '';
  var count = (count > 0) ? $('<span/>').addClass('facet-count').text(' ('+count+')') : '';
  var link = $('<a href="#" />').text(name).append(count).click(handler);
  return $('<li/>').addClass(cssClasses).append(link);
};

/**
 * Theme a single facet checkbox with associated label, wrap in a list item
 *
 * @param {String} name Facet item name, used for label
 * @param {Integer} count Count of results associated with facet item
 * @param {Boolean} checked Whether or not the checkbox is checked
 * @param {String} cssClass CSS Classes to add to list item
 * @param {String} id ID to use for checkbox element and 'for' attribute on label
 * @param {Function} handler Change handler to bind to checkbox
 */
AjaxSolr.theme.prototype.facet_checkbox = function (name, count, checked, cssClass, id, handler) {
  var text = (count > 0) ? name+' ('+count+')' : name;
  if (count == 0) cssClass += ' empty';
  var checkbox = $('<input type="checkbox" />').attr('id', id).attr('name', name).change(handler);
  var label = $('<label></label>').addClass('facet-item-label').attr('for', id).text(text);
  if (checked) {
    checkbox.attr('checked', checked);
  }
  return $('<li/>').addClass(cssClass).append(checkbox).append(label);
};

/**
 * Theme a single search result
 *
 * @param {Object} doc Solr document
 * @param {String} snippet Highlighted text snippet
 * @param {Boolean} national Where this is a national search result
 */
AjaxSolr.theme.prototype.result = function (doc, snippet, national) {
  var output = '';
  var displayURI = doc.URI.replace("individual","display");
  if (doc['dp_familyName'] !== undefined) {
  	var dp_givenName = "";
  	if (doc['dp_givenName'] !== undefined) {
  		dp_givenName = doc['dp_givenName'];
  	} 
  	if (doc['dp_preferredName'] !== undefined) {
  		dp_givenName = doc['dp_preferredName'];
  	}
  	output = '<strong><a href="'+displayURI+'">'+doc['dp_familyName']+', '+dp_givenName+'</a> </strong>';
  } else {
  	output = '<strong><a href="'+displayURI+'">'+doc['dp_label']+'</a> </strong>';
  }
  
  if (doc['dp_preferredTitle'] !== undefined) {
  	output += '<em> - '+doc['dp_preferredTitle']+'</em><br />';
  }
  
  var showHighlight = true;
  //Authors
  if (doc['op_label_informationResourceInAuthorship'] !== undefined) {
  	showHighlight = false;
    output += '<div class="result-array"><span class="array-desc">Authors:</span><span class="array-values">'+doc['op_label_informationResourceInAuthorship'].join(',')+'</span></div>';
  }
  
  if (doc.op_context_allResearchAreas !== undefined) {
  	showHighlight = false;
    output += '<div class="result-array"><span class="array-desc">Research Keywords:</span><span class="array-values">'+doc.op_context_allResearchAreas.join(',')+'</span></div>';
  }
  
  if (doc['currentMemberOf'] !== undefined && doc['labels_currentMemberOf'] !== undefined) {
  	showHighlight = false;
  	output += '<div class="result-array"><span class="array-desc">Affiliations:</span><span class="array-values">';
  	$.each(
		doc['labels_currentMemberOf'],
		function( intIndex, objValue ){
			output += '<a href="'+doc['currentMemberOf'][intIndex]+'">'+objValue+'</a> ,';
		});
	output += '</span></div>';
   
  }
  
  //Researcher
  if (doc['op_authorInAuthorship'] !== undefined || doc['op_context_hasPrincipalInvestigatorRole'] !== undefined || doc['op_context_hasInvestigatorRole'] !== undefined) {
  	output += '<span class="result-footerDesc">Quick look: </span>';
  }
  if (doc['op_authorInAuthorship'] !== undefined ) {
  	showHighlight = false;
  	var plural = 's';
  	if (doc['op_authorInAuthorship'].length == 1){
  		plural = '';
  	}
  	output += '<span class="result-footerLinks"><strong>'+doc['op_authorInAuthorship'].length+'</strong> <a href="'+doc.URI+'#publications">Publication'+plural+'</a></span>';
  }
 
  if (doc['op_context_projectLabel'] !== undefined ) {
  	showHighlight = false;
  	var plural = 's';
  	if (doc['op_context_projectLabel'].length == 1){
  		plural = '';
  	}
  	output += '<span class="result-footerLinks">| Investigator on <strong>'+doc['op_context_projectLabel'].length+' </strong><a href="'+doc.URI+'#projects">Project'+plural+'</a></span>';
  }
  //Projects
  if (doc['dp_issued'] == undefined ) {
	  if (doc['op_context_startYear'] !== undefined ) {
		showHighlight = false;
		var commapos = doc['op_context_startYear'].indexOf(",");
		var yrStr = doc['op_context_startYear'];
		
		if (doc['op_context_startYear'] !== undefined ) {
			yrStr = doc['op_context_startYear'];
		} else if (commapos > 0) {
			yrStr = yrStr.substring(0,commapos);
		}
		output += '<span class="result-footerLinks"><strong>Start Year:</strong> '+yrStr+'</span>';
	  }
	  if (doc['op_context_endYear'] !== undefined ) {
		showHighlight = false;
		var commapos = doc['op_context_endYear'].indexOf(",");
		var yrStr = doc['op_context_endYear'];
		
		if (doc['op_context_endYear'] !== undefined ) {
			yrStr = doc['op_context_endYear'];
		} else if (commapos > 0) {
			yrStr = yrStr.substring(0,commapos);
		}
		output += '<span class="result-footerLinks"><strong>End Year:</strong> '+yrStr+'</span>';
	  }
  }
  
   //Publications
   
  if (doc['dp_issued'] !== undefined ) {
  	showHighlight = false;
  	output += '<span class="result-footerLinks"><strong>Year:</strong> '+doc['dp_issued']+'</span>';
  }
  if (doc['dp_isbn'] !== undefined ) {
  	showHighlight = false;
  	output += '<span class="result-footerLinks"><strong>ISBN:</strong> '+doc['dp_isbn']+'</span>';
  }
  if (doc['dp_volume'] !== undefined ) {
  	showHighlight = false;
  	output += '<span class="result-footerLinks"><strong>Volume:</strong> '+doc['dp_volume']+'</span>';
  }
  if (doc['dp_chapter'] !== undefined ) {
  	showHighlight = false;
  	output += '<span class="result-footerLinks"><strong>Chapter:</strong> '+doc['dp_chapter']+'</span>';
  }
  if (doc['dp_pageStart'] !== undefined ) {
  	showHighlight = false;
  	output += '<span class="result-footerLinks"><strong>Pages:</strong> '+doc['dp_pageStart'];
  	if (doc['dp_pageEnd'] !== undefined ) {
  		output += '-'+doc['dp_pageEnd'] + '</span>';
  	}
  }
  //Groups
  	var relatedResearchers = 0;
 	if (doc['op_label_relatedRole'] !== undefined ) {
 		relatedResearchers += doc['op_label_relatedRole'].length;
 	}
 	if (doc['op_context_memberRoleOf'] !== undefined ) {
 		relatedResearchers += doc['op_context_memberRoleOf'].length;
 	}
 	if (doc['op_context_primaryAffiliationRoleOf'] !== undefined ) {
 		relatedResearchers += doc['op_context_primaryAffiliationRoleOf'].length;
 	}
 	
 	
 	if (relatedResearchers > 0 ) {
		showHighlight = false;
		var plural = '';
		if (relatedResearchers > 1){
			plural = 's';
		}
		
		output += '<br /><span class="result-footerLinks"><strong>'+relatedResearchers+'</strong> Related Researcher'+plural+'</span>';
  	}
  
  //Groups
  
 	if (doc['op_label_relatedProject'] !== undefined ) {
  	showHighlight = false;
  	var plural = 's';
  	if (doc['op_label_relatedProject'].length == 1){
  		plural = '';
  	}
  	if (relatedResearchers == 0 ) {
  		//output += '<br />';
  	}
  	output += '<span class="result-footerLinks"><strong>'+doc['op_label_relatedProject'].length+'</strong> Related Project'+plural+'</span>';
  }
 
 
  if(showHighlight) { //Only show highlight if we dont have anything else to display
  	output += '<p>' + snippet + '</p>';
  }
  // output += '<em class="uri">' + doc.URI + '</em>';
  return output;
};

/**
 * Theme the spinner image displayed during AJAX calls
 */
AjaxSolr.theme.prototype.loader_image = function() {
  return '<img style="display:block;margin:0 auto;padding:50px 0" src="'+site_url+'/js/search/prototype_files/loading-squarecircle.gif" />';
}

/**
 * Theme a "Show all" link for facets
 *
 * @param {Function} handler Click handler to attach to link
 */
AjaxSolr.theme.prototype.facet_showall_link = function(handler) {
  return $('<a href="#" />').addClass('facet-showall').text('Show all...').click(handler);
}

/**
 * Message displayed when there are no results
 *
 * @param {String} queryText The text entered by the user
 * @param {String} resultType The active category name (ex: people, events, organizations etc.)
 */
AjaxSolr.theme.prototype.empty_results = function(queryText, resultType) {
  output = '<div class="empty-results">';
  output += '<p>Your search - ' + queryText + ' - did not match any ' + resultType + '.</p>';
  output += 'Suggestions:';
  output += '<ul>';
  output += '<li>Double check spelling of search terms.</li>';
  output += '<li>Try fewer terms.</li>';
  output += '<li>Use broader terms.</li>'
  output += '</ul></div>';
  return output;
}

/**
 * Appends the given items to the given list, optionally inserting a separator
 * between the items in the list.
 *
 * Copied from ajaxsolr.theme.js
 *
 * @param {String} list The list to append items to.
 * @param {Array} items The list of items to append to the list.
 * @param {String} [separator] A string to add between the items.
 */
AjaxSolr.theme.prototype.list_items = function (list, items, separator) {
  jQuery(list).empty();
  for (var i = 0, l = items.length; i < l; i++) {
    var li = jQuery('<li/>');
    if (AjaxSolr.isArray(items[i])) {
      for (var j = 0, m = items[i].length; j < m; j++) {
        if (separator && j > 0) {
          li.append(separator);
        }
        li.append(items[i][j]);
      }
    }
    else {
      if (separator && i > 0) {
        li.append(separator);
      }
      li.append(items[i]);
    }
    jQuery(list).append(li);
  }
};

})(jQuery);
