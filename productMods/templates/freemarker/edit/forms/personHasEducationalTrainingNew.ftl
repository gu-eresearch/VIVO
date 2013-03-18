<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- this is in request.subject.name -->

<#-- leaving this edit/add mode code in for reference in case we decide we need it -->

<#import "lib-vivo-form.ftl" as lvf>

<#assign subjectName=""/>
<#assign roleActivityUri="mysteryRoleActivityURI"/>
<#assign orgLabel="mysteryOrgLabel"/>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />
<#assign htmlForElements = editConfiguration.pageData.htmlForElements />

<#--Retrieve variables needed-->
<#assign orgTypeValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "orgType")! />
<#assign orgLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "orgLabel")! />
<#assign deptValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "dept")! />
<#assign infoValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "info")! />
<#assign majorFieldValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "majorField")! />
<#assign degreeValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "degree")! />
<#assign degreeLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "degreeLabel")! />
<#assign degreeAbbrevValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "degreeAbbrev")! />
<#assign existingOrgValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "org")! />
<#assign existingOrgs = lvf.getFormFieldValue(editSubmission, editConfiguration, "org")! />

<#assign allExistingDegrees = editConfiguration.pageData.allExistingDegrees!/>
<#assign allExistingOrgs = editConfiguration.pageData.allExistingOrgs!/>
<#assign educationInstitutionsMap = editConfiguration.pageData.educationInstitutionsMap!/>
<#assign educationInstitutionsList = editConfiguration.pageData.educationInstitutionsList!/>



<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
	<#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#if editMode == "edit">    
		<#assign titleVerb="Edit">        
		<#assign submitButtonText="Edit Educational Training">
		<#assign disabledVal="disabled">
<#else>
		<#assign titleVerb="Create">        
		<#assign submitButtonText="Educational Training">
		<#assign disabledVal=""/>
</#if>

<#if orgTypeValue??>
	<#if orgTypeValue == "">
		<#assign orgTypeValue="http://vivoweb.org/ontology/core#University">        
	</#if>
<#else>
	<#assign orgTypeValue="http://vivoweb.org/ontology/core#University">        
</#if>

<#if orgTypeValue??>
<#else>
	<#assign orgTypeValue="http://vivoweb.org/ontology/core#University">        
</#if>


<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign yearHint     = "<span class='hint'>(YYYY)</span>" />

<style>
	.ui-autocomplete { height: 200px; overflow-y: scroll; overflow-x: hidden;}
	div#errorMessage {display:none;}
</style>
<div id="form-wrapper">
	<h2>${titleVerb}&nbsp;educational training entry for ${subjectName}${editConfiguration.subjectName}</h2>



	<script type="text/javascript">
		var exisitngOrgData = [];
		var exisitngDegreeData = [];
	</script>
	
	

	<#list allExistingOrgs as org>
		<script type="text/javascript">
			exisitngOrgData.push({
				"id": "${org.org!}",
				"title": "${org.label!}",
				"label": "${org.label!}"
			});
		</script>         
	</#list>    

	<#list allExistingDegrees as deg>
		<script type="text/javascript">
			exisitngDegreeData.push({
				"id": "${deg.degree!}",
				"title": "${deg.label!}",
				"abbrev": "${deg.abbreviation!}",
				"label": "${deg.label!}"
			});
		</script>         
	</#list> 




	<#--Display error messages if any-->
	<#if submissionErrors?has_content>
		<section id="error-alert" role="alert">
			<img src="${urls.images}/iconAlert.png" width="24" height="24" alert="Error alert icon" />
			<p>
			<#--below shows examples of both printing out all error messages and checking the error message for a specific field-->
			<#list submissionErrors?keys as errorFieldName>
				<#if errorFieldName == "startField">
					<#if submissionErrors[errorFieldName]?contains("before")>
						The Start Year must be earlier than the End Year.
					<#else>
						${submissionErrors[errorFieldName]}
					</#if>
					<br />
				<#elseif errorFieldName == "endField">
					<#if submissionErrors[errorFieldName]?contains("after")>
						The End Year must be later than the Start Year.
					<#else>
						${submissionErrors[errorFieldName]}
					</#if>
				</#if>
			</#list>
			<#--Checking if Org Type field is empty-->
			 <#if lvf.submissionErrorExists(editSubmission, "orgType")>
				Please select a value in the Organisation Type field.
			</#if>
			<#--Checking if Org Name field is empty-->
			 <#if lvf.submissionErrorExists(editSubmission, "orgLabel")>
				Please enter or select a value in the Name field.
			</#if>
			
			</p>
		</section>
	</#if>

	<@lvf.unsupportedBrowser urls.base /> 

	<section id="personHasEducationalTraining" role="region">        
		
		<form name="personHasEducationalTrainingForm" id="personHasEducationalTrainingForm" class="customForm noIE67" action="${submitUrl}"  role="add/edit educational training">

		<#if educationInstitutionsList??>
		<p class="inline">    
			<label for="orgType">Organisation Type ${requiredHint}</label>
			<select id="typeSelector" name="orgType" ${disabledVal}>
			<#list educationInstitutionsList as inst>
				<#list inst?keys as key>             
					<#if orgTypeValue = key>
						<option value="${key}"  selected="selected" >${inst[key]}</option>     
					<#else>
						<option value="${key}">${inst[key]}</option>
					</#if>             
				</#list>
			</#list>	
			</select>   
		</p> 
		</#if> 
		
		<p>
			<label for="relatedIndLabel"><span id="variable-label">Organisation</span> Name ${requiredHint}</label>
			<input class="acSelector123" size="50"  type="text" id="relatedIndLabel" name="orgLabel" value="${orgLabelValue}" <#if (disabledVal!?length > 0)>disabled="${disabledVal}"</#if> />
			<input type="hidden" name="orgId" id="orgId" value=""/>
		</p>
		
		<#--Store values in hidden fields-->
		<#if editMode="edit">
			<input type="hidden" name="orgType" id="orgType" value="${orgTypeValue}"/>
			<input type="hidden" name="orgLabel" id="orgLabel" value="${orgLabelValue}"/>
		</#if>
		
		
		<div style="display:none;">
			<p>
				<label for="dept">Department or School Name within the ###</label>
				<input  size="60"  type="text" id="dept" name="dept" value="${deptValue}" />
			</p>
		</div>
		
		
		
		<div class="entry">
		<p>
		  <label for="degreeUri">Degree ${requiredHint}</label>      
		  <input type="text" id="degreeName" name="degreeName" size="50" value="${degreeLabelValue!}" />
		  <input type="hidden" name="degree" id="degreeUri" value="${degreeValue!}"/>
		</p>
		<p>
			<label for="degreeAbbrev">Degree Abbreviation ${requiredHint}</label>      
			<input type="text" disabled="disabled" id="degreeAbbrev" name="degreeAbbrev" size="10" value="${degreeAbbrevValue!}" placeholder="Please Enter Degree Abbreviation ..."  />
		</p>
		
		</div>
		
		<p></p>
		<#--Need to draw edit elements for dates here-->
		 <#if htmlForElements?keys?seq_contains("startField")>
				Start ${htmlForElements["startField"]} ${yearHint}
		 </#if>
		 <p></p>
		 <#if htmlForElements?keys?seq_contains("endField")>
				End ${htmlForElements["endField"]} ${yearHint}
		 </#if>
										
		<#--End draw elements-->
	
		<div class="message" id="errorMessage"></div>
		
		<p id="requiredLegend" class="requiredHint" style="margin-bottom:10px;">* required fields</p>
		<input type="hidden" id="editKey" name="editKey" value="${editKey}"/>
		<p class="submit">
			<input type="button" id="saveButton" name="saveButton" class="button green" value="Save" /><span class="or"> or </span>
			<!--<input type="submit" id="submitButton" value="${submitButtonText}"/>-->
			<a class="cancel" href="${cancelUrl}" title="Cancel">Cancel</a>
		</p>
		<br/>
	</form>


	<script type="text/javascript">
	var newDegree = false;
	var selectedDegree = "";
	var selectedDegreeLabel = "${degreeLabelValue}";
	var exisitngDegreeUri = "${degreeValue}";
	var readyToSubmit = false;

	var customFormData  = {
		acUrl: '${urls.base}/autocomplete?tokenize=true&stem=true',
		editMode: '${editMode}',
		submitButtonTextType: 'compound',
		defaultTypeName: 'organization'
	};


	function doSubmit() {
		if (newDegree) {
			
			if ($('#degreeName').val().length > 0 ) {
			
				var theDegreeAbbr = $('#degreeAbbrev').val();
				if (theDegreeAbbr.length > 0) {
					//var theDegreeName = theDegreeAbbr + ' ' + $('#degreeName').val();
					var theDegreeName = $('#degreeName').val();
					addNewIndividual('http://vivoweb.org/ontology/core#AcademicDegree', theDegreeName);
				} else {
					var errorMsg = "Please fill inn the Degree Abbreviation field.";
					$('#errorMessage').html(errorMsg);
					$('#degreeAbbrev').focus();
					return false;
				}
			} else {
				var errorMsg = "Error - Please fill inn the Degree Name field.";
					$('#errorMessage').html(errorMsg).fadeIn(500);
					$('#degreeName').focus();
					return false;
			}
			
		} else {
			document.forms["personHasEducationalTrainingForm"].submit();
		}
		
		return true;
	   
	}

	function addNewIndividual(individualURI, individualLabel) {
				
		$.ajax({
			url: "${urls.base}/edit/primitiveAdd",
			type: 'GET', 

			data: {
				newObjectType: individualURI,
				newObjectLabel: individualLabel
			},

			dataType: 'json',
			context: $('#addTermButton'), // context for callback
			complete: function(request, status) {
				var newObjectURI = request.responseText;
				if ( newObjectURI.indexOf('/individual/ngen') > -1 ) {
					//console.log('new degree uri is: ' + newObjectURI);
					$('#degreeUri').val(newObjectURI);
					//generate n3 for abbreviation triple
					var n3String = "<" + newObjectURI + "> <http://vivoweb.org/ontology/core#abbreviation> \""+ $('#degreeAbbrev').val() +"\" .";
					//console.log(n3String);
					$.ajax({
						url: "${urls.base}/edit/primitiveRdfEdit",
						type: 'POST', 
						data: {
							retractions: "", 
							additions: n3String
						},
						dataType: 'json',
						context: $('#personHasEducationalTrainingForm'), // context for callback
						complete: function(request, status) {
							if (status === 'success') {
								document.forms["personHasEducationalTrainingForm"].submit();
							} else {	
								//alert('Error processing request: terms not saved');
							}
			
						}
			
					});
				}
			}

		});
		
		return false;
	}


	$(function() {
		$.widget("ui.customautocomplete", $.extend({}, $.ui.autocomplete.prototype, {
		  _response: function(contents){
			  $.ui.autocomplete.prototype._response.apply(this, arguments);
			  $(this.element).trigger("autocompletesearchcomplete", [contents]);
		  }
		}));

		$( "#relatedIndLabel" ).autocomplete({
			minLength: 1,
			source: exisitngOrgData,
			focus: function( event, ui ) {
				$( "#relatedIndLabel" ).val( ui.item.label );
				return false;
			},		
			select: function( event, ui ) {
				$( "#relatedIndLabel" ).val( ui.item.label );
				$( "#orgId" ).val( ui.item.id );
				return false;
			}
		});
		
		
		$( "#degreeName" ).customautocomplete({
			minLength: 1,
			source: exisitngDegreeData,
			focus: function( event, ui ) {
				$( "#degreeName" ).val( ui.item.label );
				return false;
			},
			select: function( event, ui ) {
				$( "#degreeName" ).val( ui.item.label );
				$( "#degreeUri" ).val( ui.item.id );
				$( "#degreeAbbrev" ).val( ui.item.abbrev );
				selectedDegree = ui.item.id;
				selectedDegreeLabel = ui.item.label;
				
				return false;
			}
		});
		
		$("input").bind("autocompletesearchcomplete", function(event, contents) {
			if (contents.length == 0 ) {
				newDegree = true;
				selectedDegree = "";
			} else {
				newDegree = false;
			}
		});
		
		$('#degreeName').blur(function() {
			
			if ( selectedDegreeLabel != $(this).val() ) {
				newDegree = true;
				$("#degreeAbbrev").removeAttr('disabled').focus();
			} 
		   
		});
		
		
		
		$('#saveButton').click(function() {
			doSubmit();
			
			return false;
		});
		
		
	});


	</script>

	</section>
</div>
<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />
<link rel="stylesheet" href="${urls.base}/edit/forms/css/customForm.css" />
<link rel="stylesheet" href="${urls.base}/edit/forms/css/customFormWithAutocomplete.css" />


<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>
<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>
<script type="text/javascript" src="${urls.base}/js/extensions/String.js"></script>
<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.bgiframe.pack.js"></script>
<script type="text/javascript" src="${urls.base}/edit/forms/js/customFormWithAutocomplete.js"></script>
<!-- GU Common Scripts -->
<script type="text/javascript" src="${urls.base}/edit/forms/js/editInterfaceCommonScripts.js"></script>

<!-- temporary include of cookie script until next build, 060612 -->
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.cookie.js"></script>