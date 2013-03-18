<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">
<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">

<#assign issued 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/issued")!> 
<#assign shortDescription 	= propertyGroups.pullProperty("http://purl.org/ontology/bibo/shortDescription")!>
<#assign description 		= individual.getObjectPropertyAsString("http://purl.org/dc/terms/description")!> 
<#assign accessRights 		= individual.getObjectPropertyAsString("http://purl.org/dc/terms/accessRights")!> 
<#assign rights 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/rights")!> 
<#assign contributor 		= propertyGroups.pullProperty("http://purl.org/dc/terms/contributor")!> 
<#assign temporal 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/temporal")!> 
<#assign spatial 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/spatial")!> 
<#assign theTitle 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/title")!> 
<#assign publisher 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/publisher")!> 
<#assign collectors 		= individual.getObjectPropertyAsString("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#hasCollector")!> 
<#assign digitalObjectIdentifier = propertyGroups.pullProperty("http://purl.org/ontology/bibo/doi")!>
<#assign relatedProject 	= propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/relatedProject")!> 
<#assign address 			= propertyGroups.pullProperty("${core}mailingAddress")!>
<#assign subjectAreas 		= propertyGroups.pullProperty("${core}hasSubjectArea")!> 
<#assign weblinks 			= propertyGroups.pullProperty("${core}webpage")!> 
<#assign isManagedBy 		= propertyGroups.pullProperty("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#isManagedBy")!> 
<#assign isOwnedBy 			= propertyGroups.pullProperty("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#isOwnedBy")!> 
<#assign hasPointOfContact 	= propertyGroups.pullProperty("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#hasPointOfContact")!> 
<#assign isOutputOf 		= propertyGroups.pullProperty("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#isOutputOf")!> 
<#assign hasCollector 		= propertyGroups.pullProperty("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#hasCollector")!> 
<#assign relations 			= propertyGroups.pullProperty("http://purl.org/dc/terms/relation")!> 

<script type="text/javascript">

	var solrServerUrl 	= "${urls.solr}/";
	var site_url 		= "${urls.base}";
		
		var solrQueryUrl = solrServerUrl + 'select?facet=false&'+
		'fl=nameRaw,op_context_mostSpecificType,dp_accessRights,dp_spatial,dp_temporal&'+
		'rows=1&'+
		'json.nl=map&'+
		'q=URI:"${individual.uri}"&'+
		'wt=json';
		
		var indRecord = null;
		//get solr results for graph   
		$.ajax({
		  url: solrQueryUrl,
		  success: function(data) {   
			//convert the json to a js object
			var tempData = $.parseJSON(data);
			
			indRecord = tempData.response.docs[0]
			if (indRecord) {
				if ( typeof indRecord.dp_accessRights != 'undefined' ) {
					var html = '<tr>'+
						'<td class="keyCol">'+
							'Access Rights'+
						'</td>'+
						'<td class="valueCol">'+
							indRecord.dp_accessRights+
						'</td>'+
					'</tr>';
					//print it to screen
					$('#propertyTable').append(html);
				}
				
				if ( typeof indRecord.dp_spatial != 'undefined' ) {
					var html = '<tr>'+
						'<td class="keyCol">'+
							'Spatial'+
						'</td>'+
						'<td class="valueCol">'+
							indRecord.dp_spatial+
						'</td>'+
					'</tr>';
					//print it to screen
					$('#propertyTable').append(html);
				}
				
				if ( typeof indRecord.dp_temporal != 'undefined' ) {
					var html = '<tr>'+
						'<td class="keyCol">'+
							'Temporal'+
						'</td>'+
						'<td class="valueCol">'+
							indRecord.dp_temporal+
						'</td>'+
					'</tr>';
					//print it to screen
					$('#propertyTable').append(html);
				}
			}
		  }
		});
		
</script>


<div id="breadcrumbs">
	<ul>
	<li><a href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a href="${urls.base}/services">Services</a>&nbsp;&nbsp;&raquo;</li>
	<li>
	<#if (title?length > 100)>
		<span>${title?substring(0, 99)}</span><span> ...</span>
		
	<#else>
		${title}
	</#if>

	</li>
	</ul>
</div>
    
<section id="individual-intro" class="vcard person" role="region">

        <#-- Image -->           
        <#assign individualImage>
            <@p.image individual=individual 
                      propertyGroups=propertyGroups 
                      namespaces=namespaces 
                      editable=editable 
                      showPlaceholder="always" 
                      placeholder="${urls.images}/placeholders/service.thumbnail.jpg" />
        </#assign>

        <#if ( individualImage?contains('<img class="individual-photo"') )>
            <#assign infoClass = 'class="withThumb"'/>
        </#if>
        <#global inTopSection = "1" >
        
        
               
        <!-- ************   NEW STRUCTURE START  -->
        
        <div id="topSectioMainWrapper">
        	<#if ( individualImage?contains('<img class="individual-photo"') )>
				<div id="topSectionPhotoWrapper" class="float">
					<div id="photo-wrapper">${individualImage}</div>
				</div><!--end topSectionPhotoWrapper -->
			</#if>
			
			<div id="topSectionDetailsWrapper" class="float non-person-entity">
				<#if relatedSubject??>
					<h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
					<p><a href="${relatedSubject.url}">&larr; return to ${relatedSubject.name}</a></p>
				<#else>                
					<h1 class="fn foaf-person">
						<#-- Label -->
						<@p.label individual editable 0 />
						 <#-- Issued -->
						
						<#if issued?has_content>
							(<span class="pubIssuedYear" itemprop="datePublished"><#list issued as statement>${statement!}</#list></span>)
						</#if> 

					</h1>
					
				</#if>
			</div><!--end topSectionDetailsWrapper -->
			
        
        </div><!--end topSectioMainWrapper -->
        <#global inTopSection = "0" >
        <!-- ************    NEW STRUCTURE END  -->

</section>

<#if individual.showAdminPanel>
	<#include "individual-adminPanel.ftl">
</#if>





<div class="propertyGroup_tab_wrapper">
		<section class="property-group non-person-entity record">

			
			


	 		<#-- shortDescription -->
			<#if shortDescription?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="property" role="article">
					<h3>Service Description</h3>
					<ul class="property-list" style="padding-bottom:0px;">
						<li role="listitem" class="dataprop_text">
							<@p.addLinkWithLabel shortDescription editable />
							<#list shortDescription.statements as statement>
							${statement.value}
							<@p.editingLinks "${shortDescription.localName}" statement editable />
							</#list>
						</li>
					</ul>
				</article>
			</#if>


			<article class="property" role="article" id="service-record">
				<h3>Service Record</h3>
				
				<ul class="property-list">

					<table class="propertyTable">

						<#-- description -->
						
						<#if description?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Service Type
								</td>
								<td class="valueCol">
									<span>
										<#list description as statement>
											${statement!}
										</#list>
									</span>
								</td>
							</tr>
						</#if> 


					
						<#-- accessRights -->
						<#if accessRights?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Access Rights
								</td>
								<td class="valueCol">
									<span>
										<#list accessRights as statement>
											${statement!}
										</#list>
									</span>
								</td>
							</tr>
						</#if> 
						
						<#-- rights -->
						<#if rights?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Rights
								</td>
								<td class="valueCol">
									<span>
										<#list rights as statement>
											${statement!}
										</#list>
									</span>
								</td>
							</tr>
						</#if> 
						
						
						
						<#-- contributor -->
						
						<#if contributor?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Contributor
								</td>
								<td class="valueCol">
									<#list contributor.statements as statement>
										${statement.value}
										<@p.editingLinks "${contributor.localName}" statement editable />
									</#list>
								</td>
							</tr>
						</#if> 
						
						<#-- temporal -->
						
						<#if temporal?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Temporal Coverage
								</td>
								<td class="valueCol">
									<#list temporal as statement>
										${statement!}
									</#list>
								</td>
							</tr>
						</#if> 
						
						<#-- spatial -->
						
						<#if spatial?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Spatial Coverage
								</td>
								<td class="valueCol">
									<#list spatial as statement>
										${statement!}
										<@p.editingLinks "${spatial.localName}" statement editable />
									</#list>
								</td>
							</tr>
						</#if> 
					

						<#-- Issued -->
						<#if issued?has_content>
							<tr>
								<td class="keyCol">
									Year Published
								</td>
								<td class="valueCol">
									<span>
									<#list issued as statement>
										${statement!}
									</#list>
									</span>
								</td>
							</tr>
						</#if>				


						
						
						<#-- START *******  statements for properties used in vitro-test service -->
						
						<#-- DOI -->
						
						<#if digitalObjectIdentifier?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Digital Object Identifier
								</td>
								<td class="valueCol">
									<@p.addLink digitalObjectIdentifier editable />
									<#list digitalObjectIdentifier.statements as statement>
										<#assign doi = statement.value!>
									<li role="listitem" class="dataprop_text">   
										<a href="http://dx.doi.org/${statement.value}" target="_blank">${statement.value}</a>
										<@p.editingLinks "${digitalObjectIdentifier.localName}" statement editable />
									</li>
									</#list>
								</td>
							</tr>
						</#if> 
						
						<#-- address -->
						
						<#if address?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Location
								</td>
								<td class="valueCol">
									<@p.objectProperty address editable />
								</td>
							</tr>
						</#if> 

						
						
						
					</table>  
				</ul>
			</article>

			
			<#-- relation -->
			
			<#if relatedProject?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="property" role="article" id="related-projects">
					<h3>Related Projects</h3>
					<ul class="property-list">
						<@p.objectProperty relatedProject editable />
					</ul>
				</article>
			</#if> 

		</section>

			<#-- Research Areas -->
			
			<#if subjectAreas?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Research Area(s)
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty subjectAreas editable />
					</ul>
				</article>
			</#if> 
			
			

			<#if relations?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Affiliation
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty relations editable />
					</ul>
				</article>
			</#if> 

		<#-- isManagedBy -->
			
			<#if isManagedBy?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Managed By
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty isManagedBy editable />
					</ul>
				</article>
			</#if> 
			
			<#-- isOwnedBy -->
			
			<#if isOwnedBy?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Owned By
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty isOwnedBy editable />
					</ul>
				</article>
			</#if> 
			
			<#-- hasPointOfContact -->
			
			<#if hasPointOfContact?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Point Of Contact
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty hasPointOfContact editable />
					</ul>
				</article>
			</#if> 
			
			<#-- isOutputOf -->
			
			<#if isOutputOf?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Output Of
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty isOutputOf editable />
					</ul>
				</article>
			</#if> 


			<#-- weblinks -->
			<#if weblinks?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<article class="sidebar-list property" role="article">
					<h3>
						Links
					</h3>
					<ul class="subclass-property-list">
						<@p.objectProperty weblinks editable />
					</ul>
				</article>
			</#if>
			
			

				
	
</div>
