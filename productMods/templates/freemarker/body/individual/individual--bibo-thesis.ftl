<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">

<#-- BEGIN - AltMetric Script - See: http://api.altmetric.com/embeds.html for details.  -->
<script type='text/javascript' src='https://d1bxh8uas1mnw7.cloudfront.net/assets/embed.js'></script>
<#-- END - AltMetric Script -->

<#-- BEGIN - Impact Story Script - See: http://impactstory.org/api-docs for details  -->
<script type="text/javascript" src="http://impactstory.org/embed/v1/impactstory.js"></script>
<#-- END - AltMetric Script -->


<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">

<#assign authors 					= propertyGroups.pullProperty("${core}informationResourceInAuthorship")!> 
<#assign primarySupervisors 		= propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/primaryRHDSupervisorRoleOf")!>
<#assign supervisors 				= propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/rHDSupervisorRoleOf")!>

<#assign abstract 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/abstract")!> 
<#assign issued 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/issued")!> 
<#assign editor 			= individual.getObjectPropertyAsString("http://purl.org/ontology/bibo/editor")!> 
<#assign mostSpecificType 	= individual.getObjectPropertyAsString("http://vitro.mannlib.cornell.edu/ns/vitro/0.7#mostSpecificType")!> 
<#assign theTitle 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/title")!> 
<#assign publisher 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/publisher")!> 
<#assign creators 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/creator")!> 
<#assign book_journal_name 	= individual.getObjectPropertyAsString("http://griffith.edu.au/ontology/hubextensions/book_journal_name")!> 
<#assign doi 				= individual.getObjectPropertyAsString("http://purl.org/ontology/bibo/doi")!>

<#assign researchAreas 		= propertyGroups.pullProperty("${core}hasResearchArea")!> 
<#assign subjectAreas 		= propertyGroups.pullProperty("${core}hasSubjectArea")!> 
<#assign weblinks 			= propertyGroups.pullProperty("${core}webpage")!> 

<#assign theTitle 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/title")!> 
<#assign degreeLevel 		= individual.getObjectPropertyAsString("http://purl.org/dc/terms/degreeLevel")!> 
<#assign accessRights 		= individual.getObjectPropertyAsString("http://purl.org/dc/terms/accessRights")!> 
<#assign abstract 			= individual.getObjectPropertyAsString("http://purl.org/dc/terms/abstract")!> 
					

<#assign digitalObjectIdentifier 	= propertyGroups.pullProperty("http://purl.org/ontology/bibo/doi")!>


<!--
<meta name="keywords" content="" />
<meta name="description" content="" />
-->
<!-- Dublin Core  -->
<!-- 
<link rel="schema.DC" href="http://purl.org/DC/elements/1.0/" />
<meta name="dc.date.modified" content="" />
<meta name="DC.title" content="${theTitle.value!}" />
<meta name="DC.creator" content="Author_1-Last Name, First Name" />
<meta name="DC.creator" content="Author_n-Last Name, First Name" />
<meta name="DC.subject" content="FOR_CODE" />
<meta name="DC.subject" content="Lable" />
<meta name="DC.subject" content="Others keyword_one per line" />
<meta name="DC.description" content="Abstract or title" />
<meta name="DC.publisher" content="Publisher" />
<meta name="DC.date" content="Year-Month" />
<meta name="DC.type" content="Journal Article" />
<meta name="DC.format" content="full text mime type eg. application/pdf" />
<meta name="DC.relation" content="Download/Link.pdf" />
<meta name="DC.relation" content="DOI" />
<meta name="DC.relation" content="Text Formatted Citation" />
<meta name="DC.identifier" content="link to page in Research Hub" />
<meta name="DC.rights" content="Copyright 2002 Blackwell Publishing" />
<meta name="DC.rights" content="The definitive version is available at www.blackwell-synergy.com" />
<meta name="DC.source" content="Faculty of Health; Institute of Health and Biomedical Innovation" />
-->
<!-- Google Scholar Metadata -->
<!-- 
google.identifiers.dissertation = dc.type:Thesis
google.identifiers.patent = dc.type:Patent
google.identifiers.technical_report = dc.type:Technical Report

<meta name="citation_title" content="${title}">
<meta name="citation_publisher" content="dc.publisher">
<meta name="citation_authors" content="dc.author | dc.contributor.author | dc.creator">
<meta name="citation_date" content="dc.date.copyright | dc.date.issued | dc.date.available | dc.date.accessioned">
<meta name="citation_language" content="dc.language.iso">
<meta name="citation_pmid =">
<meta name="citation_abstract_html_url" content="$handle">
<meta name="citation_fulltext_html_url =">
<meta name="citation_pdf_url" content="$simple-pdf">
<meta name="citation_keywords" content="dc.subject, dc.type">

<meta name="citation_journal_title =">
<meta name="citation_volume =">
<meta name="citation_issue =">
<meta name="citation_firstpage =">
<meta name="citation_lastpage =">
<meta name="citation_doi =">
<meta name="citation_issn" content="dc.identifier.issn">
<meta name="citation_isbn" content="dc.identifier.isbn">
<meta name="citation_conference =">

<meta name="citation_dissertation_name" content="dc.title">
<meta name="citation_dissertation_institution" content="dc.publisher">

<meta name="citation_patent_country =">
<meta name="citation_patent_number =">

<meta name="citation_technical_report_number =">
<meta name="citation_technical_report_institution" content="dc.publisher">
-->
<script type="text/javascript">
	
	var solrServerUrl 	= "${urls.solr}/";
	var site_url 		= "${urls.base}";
		
		var yahoo = 0;
		
		var solrQueryUrl = solrServerUrl + 'select?facet=false&'+
		'fl=nameRaw,op_context_mostSpecificType,op_label_publisher&'+
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
				
				
				if ( typeof indRecord.op_context_mostSpecificType != 'undefined' ) {
					var tempValue = indRecord.op_context_mostSpecificType;
					if ($.isArray(tempValue)) {
						tempValue = tempValue.pop();
					}
					
					var html = '<tr>'+
						'<td class="keyCol">'+
							'Publication Type'+
						'</td>'+
						'<td class="valueCol">'+
							tempValue+
						'</td>'+
					'</tr>';
					//print it to screen
					$('#propertyTable').prepend(html);
				}
				
			}
		  }
		});
	
</script>


<div id="breadcrumbs">
	<ul>
	<li><a href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a href="${urls.base}/publications">Publications</a>&nbsp;&nbsp;&raquo;</li>
	<li>
	<#if (title?length > 100)>
		<span>${title?substring(0, 99)}</span><span> ...</span>
		
	<#else>
		${title}
	</#if>

	</li>
	</ul>
</div>

<span itemscope itemtype="http://schema.org/ScholarlyArticle">

<section id="individual-intro" class="vcard person" role="region">

        <#-- Image -->           
        <#assign individualImage>
            <@p.image individual=individual 
                      propertyGroups=propertyGroups 
                      namespaces=namespaces 
                      editable=editable 
                      showPlaceholder="always" 
                      placeholder="${urls.images}/placeholders/publication.thumbnail.jpg" />
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
					<h1 itemprop="name">
					
						<#-- Label -->
						<@p.label individual editable 0 />
						</h1>
						 <#-- Issued -->
						<#if issued?has_content>
							(<span class="pubIssuedYear" itemprop="datePublished"><#list issued as statement>${statement!}</#list></span>)
						</#if>
					
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


	
	
	<#-- Authors -->
	<#if authors?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
		<article class="property" role="article">
			<h3>Author</h3>
			<ul class="property-list" id="authorlist">
				<@p.objectProperty authors editable />
			</ul>
		</article>
	</#if> 

	<#-- Abstract -->
	<#if abstract?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
		<article class="property" id="abstract" role="article">
			<h3>Abstract</h3>
			<ul class="property-list" style="padding-bottom:0px;">
				<li role="listitem" class="dataprop_text">
				<#--<@p.addLinkWithLabel overview editable />-->
				<span itemprop="description">
				${abstract[0]!}
				</span>
				</li>
			</ul>
	</article>
	</#if>

	

	<#-- primarySupervisors -->
	

	<article class="property" role="article">
		<h3>Thesis Record</h3>

			<ul class="property-list">

				<table class="propertyTable">

					<tr>
						<td class="keyCol">
							Publication Type
						</td>
						<td class="valueCol">
							<li role="listitem" class="dataprop_text">   
								Thesis
							</li>
						</td>
					</tr>
					
			   
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

					<#-- degreeLevel -->
					<#if degreeLevel?has_content>
						<tr>
							<td class="keyCol">
								Degree Level
							</td>
							<td class="valueCol">
								<span>
								<#list degreeLevel as statement>
									${statement!}
								</#list>
								</span>
							</td>
						</tr>
					</#if>

					<#-- accessRights -->
					<#if accessRights?has_content>
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



					<#if editor?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
						<tr>
							<td class="keyCol">
								Editor
							</td>
							<td class="valueCol">
								<span>
								<#list editor as statement>
									${statement!}
								</#list>
								</span>
							</td>
						</tr>
					</#if> 
			   

					<#if publisher?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
						<tr>
							<td class="keyCol">
								Publisher
							</td>
							<td class="valueCol">
								<span>
								<#list publisher as statement>
									${statement!}
								</#list>
								</span>
							</td>
						</tr>
					</#if> 

					
					

					

					<#-- DOI -->
						
					<#if digitalObjectIdentifier?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
						<tr>
							<td class="keyCol">
								Digital Object Identifier
							</td>
							<td class="valueCol">
								<@p.addLink digitalObjectIdentifier editable />
								<#list digitalObjectIdentifier.statements as statement>
								<li role="listitem" class="dataprop_text">   
									<a href="http://dx.doi.org/${statement.value}" target="_blank">${statement.value}</a>
									<@p.editingLinks "${digitalObjectIdentifier.localName}" statement editable />
								</li>
								</#list>
							</td>
						</tr>
					</#if> 
				   
					
					<#-- Citation -->
				
					<#if creators?has_content>
						<#if issued?has_content>
							<#if publisher?has_content>
								<#if doi?has_content>
									<tr>
										<td class="keyCol">
											Cite this publication
										</td>
										<td class="valueCol">
											<span>
											<#list creators as creator>
												${creator!}<#if creator_has_next>,</#if>
											</#list>
											(${issued[0]!}): ${theTitle[0]!}. ${publisher[0]!}. <a target="_blank" href="http://dx.doi.org/${doi!}">http://dx.doi.org/${doi!}</a>.  
											</span>
										</td>
									</tr>
								</#if>
							</#if>
						</#if>			
					</#if>		
				
			   
					 <#-- Start Page -->
					
				</table>
			</ul>
	</article>

</section>

	<#-- START SIDEBAR CONTENT -->
	<#--
	<div class="propertyGroup_tab_rightcolumn">
		<div class="propertyGroup_cta_btns" align="center">
			<a href="http://www98.griffith.edu.au/dspace/" target="_blank" title="Find This Publication on Griffith Research Online">
				<div class="side_container"><span class="ggrs_btn side_button"></span></div>
				<span class="propertyGroup_cta_txt">Find This Publication on Griffith Research Online</span>
			</a>
		</div>
	</div>
        -->

	<#if primarySupervisors?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
		<article class="sidebar-list property" role="article">
			<h3>Primary Supervisor(s)</h3>
			<ul class="subclass-property-list" id="authorlist">
				<@p.objectProperty primarySupervisors editable />
			</ul>
		</article>
	</#if> 

	<#-- Supervisors -->
	<#if supervisors?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
		<article class="sidebar-list property" role="article">
			<h3>Supervisor(s)</h3>
			<ul class="subclass-property-list" id="authorlist">
				<@p.objectProperty supervisors editable />
			</ul>
		</article>
	</#if> 

	<#-- Research Areas -->
	<#if researchAreas?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
		<article class="sidebar-list property" role="article">
			<h3>
				Research Area(s)
			</h3>
			<ul class="subclass-property-list">
				<span itemprop="keywords"><@p.objectProperty researchAreas editable /></span>
			</ul>
		</article>
	</#if>   
	
	<#-- weblinks -->
	<#global inPubLinksSection = "1" >
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
	<#global inPubLinksSection = "0" >

        <#-- AltMetrics -->
        <#if doi?has_content>
	        <article class="sidebar-list property" role="altmetrics">
	                <h3>Altmetrics</h3>
	                <ul class="subclass-property-list">
	                    <div class='altmetric-embed' data-badge-type='donut' data-badge-popover='left' data-doi="${doi[0]!}"></div>
	                    <div class="impactstory-embed" data-id="${doi[0]!}" data-id-type="doi" data-api-key="fallu-ykln9j"></div>
	                </ul>
	        </article>
        </#if>
</div>
</span>

<#-- Mocked Up COiNs meta-data below here-->
<span>
<#if doi?has_content>
<span class='Z3988' 
title='url_ver=Z39.88-2004&amp;ctx_ver=Z39.88-2004&amp;rfr_id=info%3Asid%2Fresearch-hub.griffith.edu.au%3A2&amp;rft_id=info%3Adoi%2F${doi[0]?url}&amp;rft_val_fmt=info%3Aofi%2Ffmt%3Akev%3Amtx%3Ajournal&amp;rft.genre=article&amp;rft.atitle=${title?url}&amp;rft.jtitle=The%20Lancet&amp;rft.volume=380&amp;rft.issue=9847&amp;rft.aufirst=Claire%20M&amp;rft.aulast=Rickard&amp;rft.au=Claire%20M%20Rickard&amp;rft.au=Joan%20Webster&amp;rft.au=Marianne%20C%20Wallis&amp;rft.au=Nicole%20Marsh&amp;rft.au=Matthew%20R%20McGrail&amp;rft.au=Venessa%20French&amp;rft.au=Lynelle%20Foster&amp;rft.au=Peter%20Gallagher&amp;rft.au=John%20R%20Gowardman&amp;rft.au=Li%20Zhang&amp;rft.au=Alice%20McClymont&amp;rft.au=Michael%20Whitby&amp;rft.date=2012-09&amp;rft.pages=1066-1074&amp;rft.spage=1066&amp;rft.epage=1074&amp;rft.issn=01406736'></span>
</span>
</#if>
<!-- AddThis Button BEGIN -->
<div class="addthis_toolbox addthis_floating_style addthis_counter_style" style="left:50px;top:50px;">
<#if doi?has_content>	
	<a class="addthis_button_tweet" tw:count="vertical" tw:text="${doi[0]!}"></a>
</#if>
<a class="addthis_button_google_plusone" g:plusone:size="tall"></a>
<a class="addthis_button_mendeley"> <img src="http://cache.addthiscdn.com/icons/v1/thumbs/32x32/mendeley.png" width="32" height="32"/></a>
<a class="addthis_button_facebook_like" fb:like:layout="box_count"></a>
<a class="addthis_button_citeulike addthis_32x32_style" cu:like:layout="box_count"></a>
<a class="addthis_counter"></a>
</div>
<script type="text/javascript">var addthis_config = {"data_track_clickback":false};</script>
<script type="text/javascript">var addthis_share = templates: {twitter: '{{url}} (text)',};</script>
<script type="text/javascript" src="//s7.addthis.com/js/300/addthis_widget.js#pubid=ra-513da06d750aa445"></script>

<!-- AddThis Button END -->

<#-- ${individual.getSpecificObjectProperty("http://vivoweb.org/ontology/core#webpage")} -->
