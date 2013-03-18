/*
Copyright (c) 2011, Cornell University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

	* Redistributions of source code must retain the above copyright notice,
	  this list of conditions and the following disclaimer.
	* Redistributions in binary form must reproduce the above copyright notice,
	  this list of conditions and the following disclaimer in the documentation
	  and/or other materials provided with the distribution.
	* Neither the name of Cornell University nor the names of its contributors
	  may be used to endorse or promote products derived from this software
	  without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/

$(document).ready(function(){
	
	// "more"/"less" HTML truncator for showing more or less content in data property core:overview
	$('#overview .dataprop_text').truncate({max_length: 300});
	$('#researchOverview .dataprop_text').truncate({max_length: 300});
	$('#abstract .dataprop_text').truncate({max_length: 300});
	
	$('.overview-value').truncate({max_length: 200}); 

	$('#main-nav').setnav('breadcrumbs', 'main-nav');
	$('ul.propertyList_publications > li.subclass > .subclass-property-list').truncatelist(3);
	$('.propertyList_projects').truncatelist(5);
	$('#individual-relatedProject').truncatelist(5);

	$('#authorlist').columnize({columns: 3, lastNeverTallest: true});

	$('.sidebar-list #individual-relatedRole').truncatelist(10);
	$('ul.property-list').children('h2').remove();

	var nonPersonEntityRecordHeight = $('div.propertyGroup_tab_wrapper').height();
	$('section.non-person-entity').css('min-height', nonPersonEntityRecordHeight );

	$('section.non-person-entity').css('min-height', $('section.non-person-entity').parent().height());

	$('.sidebar-list #individual-relatedRole li .tr_more').click(function(){
		var nonPersonEntityRecordHeight2 = $('div.propertyGroup_tab_wrapper').height();
		$('section.non-person-entity').css('min-height', nonPersonEntityRecordHeight2 );
		$('.sidebar-list #individual-relatedRole li .tr_less').click(function(){
			$('section.non-person-entity').css('min-height', nonPersonEntityRecordHeight );
		});
	});

	// COLUMUNIZED AND TRUNCATED COLUMNS

	// indentify element to operate on, store its content in a variable for later
	var truncColumns = $('.floatingPropertyList #individual-relatedRole');
	var truncColumnsContent = $('.floatingPropertyList #individual-relatedRole').html();

	// if list contains 2 elements, columnize to two columns and leave.
	// if list contains 3 or more elements, truncate to 15 and columnize
	if(truncColumns.children('li').size() >= 3){
		truncColumns.truncatelist(15);
		truncColumns.columnize({columns: 3, lastNeverTallest: true});
	} else if (truncColumns.children('li').size() == 2){
		truncColumns.columnize({columns: 2, lastNeverTallest: true});
	};
	
	// this function resets the elements contents using the html variable created above, then it re-truncates and columnizes
	var resetColumns = function(){
			$(this).parents(truncColumns).children().remove();
			truncColumns.append(truncColumnsContent);
			truncColumns.truncatelist(15);
			truncColumns.find('a.tr_more').click(expandColumns)
			truncColumns.columnize({columns: 3, lastNeverTallest: true});
		};
	
	// this function resets the element's contents using the html variable created above, the columnizes WITH NO TRUNCATION	
	var expandColumns = function(){
			$(this).parents(truncColumns).children().remove();
			truncColumns.append(truncColumnsContent);
			truncColumns.append('<li><a href="javascript:void(0);" class="tr_less" id="trunc-rebuild-list">less...</a><li>');
			$('#trunc-rebuild-list').click(resetColumns);
			truncColumns.columnize({columns: 3, lastNeverTallest: true});		
		};
	
	// this is the initial function call to override the default truncateList 'more' function, 
	// it needs to be called after the two new relevent functions are defined, 
	// so that they can then loop back and forth to one another.
	truncColumns.find('a.tr_more').click(expandColumns);
	
	// END COLUMUNIZED AND TRUNCATED COLUMNS

	/* use the array to to set as many info items to property heading array(id, 'title text')*/
	//var help_array_byID = {'authorInAuthorship' : 'Australian Government Reportable Research Outputs'};
	//$('article').addhelptooltip(help_array_byID, false);
	/* this is done like this because the h3 within subclass don't have ID's array({class : title text}, 'words in the h3 to search for')*/
	//$('subclass').addhelptooltip({'subclass' : 'Other Outputs'}, 'Other');
	$(".property-header img[title]").tooltip({offset: [55,120]});
	$(".property-sub-header img[title]").tooltip({offset: [35,120]});
	
	$("#visualisationInformationIcon").tooltip({offset: [35,120]});
	
	$(".publistingInfoImage").tooltip({offset: [35,120]});
	
	

  //BACKGROUND TAB PROPERTIES FOR INDIVIDUAL PROFILE PAGES
  $('wrapper-content').rhtabs('propertyGroup_tab_wrapper','property-group-menu');
   
  $('#background-properties article').each(function(){
	  numOfEntries = $(this).children('ul.propertyList_background').children('li').size();
		$(this).children('.background_property').append('('+numOfEntries+')');
  });
  
  if($('#background-properties .edit-links').html() == ''){
	$('#background-properties .edit-links').css('border-bottom', 'none');
	$('#background-properties .edit-links').css('margin', '0px');
  };
  
  $('#background-properties .edit-icons').hover(function(){
	$(this).parent('li').addClass('edit-entry-hover');
  }, function(){
	$(this).parent('li').removeClass('edit-entry-hover');
  });
  
  $('#background-properties article.property ul.property-list div.edit-links a.addEditDeleteLink').append('Add Entry');
  //END BACKGROUND TAB
});
