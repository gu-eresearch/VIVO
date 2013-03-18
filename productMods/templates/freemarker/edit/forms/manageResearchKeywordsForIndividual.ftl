<#--
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
-->
<#import "lib-vivo-form.ftl" as lvf>

<#assign existingConcepts = editConfiguration.pageData.researchKeywords!/>
<#assign existingResearchKeywords = editConfiguration.pageData.allResearchKeywords!/>

<#assign inversePredicate = editConfiguration.pageData.inversePredicate! />

<#assign baseEditResearchKeywordUrl=editConfiguration.pageData.baseEditResearchKeywordUrl!"baseEditResearchKeywordUrl is undefined">
<#assign deleteResearchKeywordUrl=editConfiguration.pageData.deleteResearchKeywordUrl!"deleteResearchKeywordUrl is undefined">
<#assign showAddFormUrl=editConfiguration.pageData.showAddFormUrl!"showAddFormUrl is undefined">



<#--If edit submission exists, then retrieve validation errors if they exist-->

<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>

	<#assign submissionErrors = editSubmission.validationErrors/>

</#if>


<style>
	 .slick-header {
				display:none !important; 
		}

		#txtSearch2 {
				width: 400px;
		}
		.slick-cell {
				font-family: Arial,sans-serif;
				font-size: 14px;
		}
		.formDesc{
				margin-bottom: 10px;
				color: #555;
				font-style: italic;
		}
		form#addConceptForm {
			display: block;
		}
		#addTermButton {
			background-image: url("/images/individual/addIcon.gif");
			float: right;
			height: 15px;
			margin-right: 19px;
			margin-top: -22px;
			position: relative;
			width: 16px;
		}
		#addTermButton:hover {
			cursor: pointer;
		}
		

</style>

<script type="text/javascript">
	if(!String.prototype.trim) {  
	  String.prototype.trim = function () {  
		return this.replace(/^\s+|\s+$/g,'');  
	  };  
	}


	var collatedAdditions = [];
	var collatedRemovals  = [];

	jQuery(document).ready(function(){
		if ($('#existingConcepts li').length < 2){
			$('#rightColumnPrompt').html('No keywords have been specified yet.');
		} else if ($('#existingConcepts li').length >= 2){
			$('#rightColumnPrompt').html('<br/>');
		}
		$('a.remove').click(function(){
			$('#rightColumnPrompt').html("<em>Click 'Save' below to confirm these changes to your profile.</em>");
		}); 	
	});

</script>
<div id="edit-interface-wrapper">

	<h2>Manage Research Keywords</h2>
	
	<div class="message purple"><a class="close_box" href="#">Close</a>
		<p><em>Add your research keywords by typing your keywords in the text box below, hit enter, or click on the <img src="/images/individual/addIcon.gif"  alt="add icon" /> button to add the research keyword to your profile. to your profile. You can also choose similar keywords that will appear below the text box when typing. When finished, please click on the Save button to apply your changes.</em></p>
		<p>If you wish to add Field Of Research (FOR) descriptors about your research, please go to <a href="${urls.base}/editRequestDispatch?subjectUri=${editConfiguration.subjectUri}&predicateUri=http%3A%2F%2Fvivoweb.org%2Fontology%2Fcore%23hasSubjectArea">Research Areas</a></p>
	</div>
	<a class="show_help" href="#">How Do I Use This Page?</a>
		



	<#if submissionErrors?has_content>

		<section id="error-alert" role="alert">

			<img src="${urls.images}/iconAlert.png" width="24" height="24" alert="Error alert icon" />

			<p>

			<#--below shows examples of both printing out all error messages and checking the error message for a specific field-->

			<#list submissionErrors?keys as errorFieldName>

				${errorFieldName} :  ${submissionErrors[errorFieldName]}

			</#list>

		   

			

			</p>

		</section>

	</#if>



	<@lvf.unsupportedBrowser urls.base/>

	<div class="noIE67">
	
	<div id="add-items">	
		<h4>Add additional Research Keyword</h4>
		
		<div id="item-search">
			Find / Add Keyword <input type="text" id="txtSearch2" class="keywords-input" /><span id="addTermButton" title="Add A New Research Keyword"></span>
		</div>
		
		<div class="grid_wrapper" style="min-height:250px;">
			<div id="myGrid" style="float:left;width:460px;"></div>		
		</div>	
		
		<div id="forCodeListWrapper">

				<script type="text/javascript">
					var forCodeData = [];
				</script>
				
				<#list existingResearchKeywords as forCode>
					<script type="text/javascript">
						forCodeData.push({
							"id": "${forCode_index + 1}",
							"conceptNodeUri": "${forCode.researchKeyword!}",
							"conceptNodeCode": "${forCode.researchKeyword!}",
							"conceptLabel": "${forCode.label!}",
							"title": "${forCode.label!}",
							"addLink": "<a title='Add Keyword' class='gridAddLink' id='gridLink_${forCode_index + 1}' href='javascript:addItem(\"${forCode_index + 1}\");' title='Add ${forCode.label!}'><img class=\"add-individual\" src=\"${urls.images}/individual/addIcon.gif\" alt=\"add\" /></a>"
						});
						
					</script>         
				  </#list>    
		</div>	
	</div>

	<div id="selected-items">

	<h4>Your selected Research Keywords</h4>

		<ul id="existingConcepts" >
		
			<script type="text/javascript">
				var existingConceptsData = [];
			</script>  
		
			<#list existingConcepts as existingConcept>
				<li class="existingConcept">
					<span class="concept">
						<span class="conceptWrapper">
										<span class="conceptURI" style="display:none;"> ${existingConcept.researchKeyword!} </span>
						   <span class="conceptLabel"> ${existingConcept.label!} </span> 
						</span>
						&nbsp;<a href="${urls.base}/edit/primitiveRdfEdit" class="remove"><img class="delete-individual" src="${urls.images}/individual/deleteIcon.gif" alt="delete" title="Remove ${existingConcept.label!}"/></a>
					</span>
				</li>    
		
				<script type="text/javascript">
					existingConceptsData.push({
						"conceptNodeUri": "${existingConcept.researchKeyword!}",
						"conceptLabel": "${existingConcept.label!}"      
					});
				</script>         
		
			  </#list>    
		
		</ul>
		
		<p id='rightColumnPrompt'>There are currently no research keywords specified.</p>

		<div id="listMessages"></div>
	</div>

	<hr/>
		<div class="buttonWrapper">
			<input type="button" id="saveButton" name="saveButton" class="button green" value="Save" />
			<input type="button" id="cancelButton" name="saveButton" class="button green" value="Cancel" />
		</div>	

	</div>
</div>



	<script type="text/javascript">

	var customFormData = {

		subjectUri: '${editConfiguration.subjectUri!}',

		predicateUri: '${editConfiguration.predicateUri!}',

		inversePredicateUri: '${inversePredicate!}'

	};

	</script>



<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />
<link rel="stylesheet" href="${urls.base}/edit/forms/css/customForm.css" />
<link rel="stylesheet" href="${urls.base}/js/jquery_plugins/SlickGrid/slick.grid.css" />
<link rel="stylesheet" href="${urls.base}/edit/forms/css/addConcept.css" />



<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>

<!-- Slickgrid Includes Start -->

<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/lib/jquery.event.drag-2.0.min.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/lib/jquery.jsonp-1.1.0.min.js"></script>

<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/slick.core.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/slick.grid.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/slick.editors.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/SlickGrid/slick.dataview.js"></script>


<!-- Slickgrid includes end -->

<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>

<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>

<script type="text/javascript" src="${urls.base}/edit/forms/js/addConceptGU.js"></script>


<!-- GU Common Scripts -->
<script type="text/javascript" src="${urls.base}/edit/forms/js/editInterfaceCommonScripts.js"></script>

<!-- temporary include of cookie script until next build, 060612 -->
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.cookie.js"></script>

<script type="text/javascript">
	var dataView;
		var grid;
		var data = [];

		var selectedRowIds = [];


		var columns = [
			{id:"code", name:"Code", field:"conceptNodeCode", width:100, minWidth:100, cssClass:"cell-title", editor:TextCellEditor, validator:requiredFieldValidator, sortable:true},
			{id:"title", name:"Field Of Research", field:"title", width:450, minWidth:450, cssClass:"cell-title", editor:TextCellEditor, validator:requiredFieldValidator, sortable:true},
			{id:"link", name:"Add", field:"addLink", width:50, minWidth:50, cssClass:"cell-title", sortable:false}
		];

		var options = {
			editable: false,
			enableAddRow: false,
			enableCellNavigation: true,
			asyncEditorLoading: true,
			forceFitColumns: false,
			topPanelHeight: 0
		};

		var sortcol = "title";
		var sortdir = 1;
		var percentCompleteThreshold = 0;
		var searchString = "";

		function requiredFieldValidator(value) {
			if (value == null || value == undefined || !value.length)
				return {valid:false, msg:"This is a required field"};
			else
				return {valid:true, msg:null};
		}

		function myFilter(item, args) {
			if (args.searchString != "" && item["title"].toLowerCase().indexOf(args.searchString.toLowerCase()) == -1) {
				return false;
			}

			return true;
		}

		function percentCompleteSort(a,b) {
			return a["title"] - b["title"];
		}

		function comparer(a,b) {
			var x = a[sortcol], y = b[sortcol];
			return (x == y ? 0 : (x > y ? 1 : -1));
		}

		function toggleFilterRow() {
			if ($(grid.getTopPanel()).is(":visible"))
				grid.hideTopPanel();
			else
				grid.showTopPanel();
		}
		
		function findItem(id) {
			
			for (var i = 0, l = forCodeData.length; i < l; i++) {
				var item = forCodeData[i];
				if (item.id == id) {
					return i;
				}
			}
			return -1;
			
		}
		
		function undoAddItem(index){
			//console.log(index);
			//console.log(collatedAdditions[index]);
			collatedAdditions[index] = " ";
			$('li.addedItem_'+index).remove();
			$('#rightColumnPrompt').html("<em>Click 'Save' below to confirm these changes to your profile.</em>");
		}
		
	   function addItem(id) {
			var dataId = findItem(id);
			
			//var row = $('#gridLink_'+id).parents('div.slick-row').attr('row');
			
			var dataObject = forCodeData[dataId];
			//console.log(dataObject);
			
			forCodeData.splice(dataId,1);
			dataView.refresh();
			
			var uri = dataObject['conceptNodeUri'];
			var label = dataObject['conceptLabel'];
			
			

			collatedAdditions.push( addConceptForm.generateAdditionN3(uri) );
			//console.log(collatedAdditions);
			var newIndex = collatedAdditions.length-1;
			$('#existingConcepts').append('<li class="existingConcept addedItem_'+newIndex+'"><span class="concept"><span class="conceptWrapper"><span class="label">'+label+'</span> </span><a href="javascript:undoAddItem('+newIndex+');"><img class="delete-individual" src="${urls.images}/individual/deleteIcon.gif" alt="delete" title="Remove Keyword"/></a></span></li>').fadeIn(400);
			$('#rightColumnPrompt').html("<em>Click 'Save' below to confirm these changes to your profile.</em>");
			
			/*
			 $.ajax({
				url: "${urls.base}/edit/primitiveRdfEdit",
	
				type: 'POST', 
	
				data: {
	
					retractions: '', 
	
					additions: addConceptForm.generateAdditionN3(uri)
	
				},
	
				dataType: 'json',
	
				context: $('#gridLink_'+id), // context for callback
	
				complete: function(request, status) {
	
					var existingConcept,
	
						conceptNodeUri;
	
				
	
					if (status === 'success') {
						
						$('#existingConcepts').append('<li class="existingConcept"><span class="concept"><span class="conceptWrapper"><span class="label">'+label+'</span> </span></span></li>').fadeIn(400);
						
					} else {
	
						alert('Error processing request: term not added');
	
					}
	
				}
	
			});
			*/
			
			
	   }
	
	
	
	$(function () {
		$('#saveButton').click(function() {
			
			additions = collatedAdditions.join(" ");
			deletions = collatedRemovals.join(" ");
			//console.log(additions);
			//console.log(deletions);
			
			$.ajax({
				url: "${urls.base}/edit/primitiveRdfEdit",
	
				type: 'POST', 
	
				data: {
	
					retractions: deletions, 
	
					additions: additions
	
				},
	
				dataType: 'json',
	
				context: $('#savebutton'), // context for callback
	
				complete: function(request, status) {
	
					if (status === 'success') {
						//alert('Saved');
						collatedAdditions = [];
						collatedRemovals  = [];
						window.location = "${cancelUrl}&url=/individual";
					} else {	
						alert('Error processing request: terms not saved');
					}
	
				}
	
			});
			
			
			return false;

		 });
		 
		 $('#cancelButton').click(function() {
			
			collatedAdditions = [];
			collatedRemovals  = [];
			
			window.location = "${cancelUrl}&url=/individual";

			return false;

		 });
	
	
		dataView = new Slick.Data.DataView();
		grid = new Slick.Grid("#myGrid", dataView, columns, options);
		//grid.setSelectionModel(new Slick.RowSelectionModel());
		//var pager = new Slick.Controls.Pager(dataView, grid, $("#pager"));


		// move the filter panel defined in a hidden div into grid top panel
		$("#inlineFilterPanel").appendTo(grid.getTopPanel()).show();

		grid.onCellChange.subscribe(function(e,args) {
			dataView.updateItem(args.item.id,args.item);
		});

		
		

		grid.onKeyDown.subscribe(function(e) {
			// select all rows on ctrl-a
			if (e.which != 65 || !e.ctrlKey)
				return false;

			var rows = [];
			selectedRowIds = [];

			for (var i = 0; i < dataView.getLength(); i++) {
				rows.push(i);
				selectedRowIds.push(dataView.getItem(i).id);
			}

			grid.setSelectedRows(rows);
			e.preventDefault();
		});

		grid.onSelectedRowsChanged.subscribe(function(e) {
			selectedRowIds = [];
			var rows = grid.getSelectedRows();
			for (var i = 0, l = rows.length; i < l; i++) {
				var item = dataView.getItem(rows[i]);
				if (item) selectedRowIds.push(item.id);
			}
		});

		grid.onSort.subscribe(function(e, args) {
			sortdir = args.sortAsc ? 1 : -1;
			sortcol = args.sortCol.field;

			if ($.browser.msie && $.browser.version <= 8) {
				// using temporary Object.prototype.toString override
				// more limited and does lexicographic sort only by default, but can be much faster

				var percentCompleteValueFn = function() {
					var val = this["percentComplete"];
					if (val < 10)
						return "00" + val;
					else if (val < 100)
						return "0" + val;
					else
						return val;
				};

				// use numeric sort of % and lexicographic for everything else
				dataView.fastSort((sortcol=="title")?percentCompleteValueFn:sortcol,args.sortAsc);
			}
			else {
				// using native sort with comparer
				// preferred method but can be very slow in IE with huge datasets
				dataView.sort(comparer, args.sortAsc);
			}
		});
		
	  

		// wire up model events to drive the grid
		dataView.onRowCountChanged.subscribe(function(e,args) {
			grid.updateRowCount();
			grid.render();
		});

		dataView.onRowsChanged.subscribe(function(e,args) {
			grid.invalidateRows(args.rows);
			grid.render();

			if (selectedRowIds.length > 0)
			{
				// since how the original data maps onto rows has changed,
				// the selected rows in the grid need to be updated
				var selRows = [];
				for (var i = 0; i < selectedRowIds.length; i++)
				{
					var idx = dataView.getRowById(selectedRowIds[i]);
					if (idx != undefined)
						selRows.push(idx);
				}

				grid.setSelectedRows(selRows);
			}
		});

		dataView.onPagingInfoChanged.subscribe(function(e,pagingInfo) {
			var isLastPage = pagingInfo.pageSize*(pagingInfo.pageNum+1)-1 >= pagingInfo.totalRows;
			var enableAddRow = isLastPage || pagingInfo.pageSize==0;
			var options = grid.getOptions();

			if (options.enableAddRow != enableAddRow)
				grid.setOptions({enableAddRow:enableAddRow});
		});



		var h_runfilters = null;

		


		// wire up the search textbox to apply the filter to the model
		$("#txtSearch,#txtSearch2").keyup(function(e) {
			Slick.GlobalEditorLock.cancelCurrentEdit();

			// clear on Esc
			if (e.which == 27) {
				this.value = "";
			}
			if(e.which == 13){
				addNewTerm(this.value);
			}


			searchString = this.value;
			updateFilter();
		});
		
		$("#addTermButton").click(function(e) {
			addNewTerm($('#txtSearch2').val());
			searchString = "";
			updateFilter();
			return false;
		});
		
		function addNewTerm(termLabel) {

			newObjectTypeURI = 'http://vivoweb.org/ontology/core#SubjectArea';
			
			$.ajax({
				url: "${urls.base}/edit/primitiveAdd",
				type: 'GET', 
	
				data: {
					newObjectType: newObjectTypeURI,
					newObjectLabel: termLabel
				},
	
				dataType: 'json',
	
				context: $('#addTermButton'), // context for callback
	
				complete: function(request, status) {
					var newObjectURI = request.responseText;
					//console.log(newObjectURI);
					if ( newObjectURI.indexOf('/individual/ngen') > -1 ) {
						//console.log('new object exists: ' + newObjectURI);
						collatedAdditions.push( addConceptForm.generateAdditionN3WithLabel(newObjectURI, termLabel, newObjectTypeURI) );
						//console.log(collatedAdditions);
						var newIndex = collatedAdditions.length-1;
						$('#existingConcepts').append('<li class="existingConcept addedItem_'+newIndex+'"><span class="concept"><span class="conceptWrapper"><span class="label">'+termLabel+'</span> </span><a href="javascript:undoAddItem('+newIndex+');"><img class="delete-individual" src="${urls.images}/individual/deleteIcon.gif" alt="delete" /></a></span></li>').fadeIn(400);
						$('#listMessages').html('Item added').fadeIn(500).fadeOut(3000).html('');
						$('#txtSearch2').val("");
					}
					
				}
	
			});
			
			
			return false;
		}
		

		function updateFilter() {
			dataView.setFilterArgs({
				searchString: searchString
			});
			dataView.refresh();
		}
		
		grid.onDblClick.subscribe(function(e, args){
			var cell = grid.getCellFromEvent(e);
			//console.log(cell);
			//console.log(e);
			var row = cell.row;
			var column = grid.getColumns()[cell.cell]; // object containing name, field, id, etc
			
			
			var dataObject = forCodeData[args.row];

			
			forCodeData.splice(args.row,1);
			dataView.refresh();
			//grid.render();
			
		});
		
		


		// initialize the model after all the events have been hooked up
		dataView.beginUpdate();
		dataView.setItems(forCodeData);
		dataView.setFilterArgs({
			searchString: searchString
		});
		dataView.setFilter(myFilter);
		dataView.endUpdate();
		
		/*
		var tmpData = [];
		tmpData["id"] 		= "1";
		tmpData["title"] 	= "Test 1 ";
		data2.push(tmpData);
		*/
	
		

		
		
		grid.updateRowCount();
		grid.render();
		grid.showTopPanel();

		
		
	})
</script>






