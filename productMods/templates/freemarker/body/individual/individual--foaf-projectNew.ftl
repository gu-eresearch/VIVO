<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">
<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">

<#assign shortDescription = propertyGroups.pullProperty("http://purl.org/ontology/bibo/shortDescription")!>
<#assign relatedRole = propertyGroups.pullProperty("${core}relatedRole")!> 
<#assign projectStateProp = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/projectstate")!>
<#assign dateTimeInterval = propertyGroups.pullProperty("${core}dateTimeInterval")!> 
<#assign relatedAgent = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/relatedAgent")!> 
<#assign relations = propertyGroups.pullProperty("http://purl.org/dc/terms/relation")!> 
<#assign weblinks = propertyGroups.pullProperty("${core}webpage")!> 
<#assign arc_project_idProp = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/arc_project_id")!>
<#assign nhmrc_project_idProp = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/nhmrc_project_id")!>
<#assign fundedBy = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/fundedBy")!>
<#assign subjectAreas = propertyGroups.pullProperty("${core}hasSubjectArea")!> 



<div id="breadcrumbs">
	<ul>
	<li><a href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a href="${urls.base}/projects">Projects</a>&nbsp;&nbsp;&raquo;</li>
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
                      placeholder="${urls.images}/placeholders/project.thumbnail.jpg" />
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
				<h3>
					Short Description
				</h3>
				<ul class="property-list" style="padding-bottom:0px;">
					<li role="listitem" class="dataprop_text">
					<@p.addLinkWithLabel shortDescription editable />
					<#list shortDescription.statements as statement>
						<div class="overview-value">
							${statement.value}
						</div>
						<@p.editingLinks "${shortDescription.localName}" statement editable />
					</#list>
					</li>
				</ul>
			</article>
		</#if>

	 	<article class="property" role="article">
			<h3>
				Project Record
			</h3>
			<ul class="property-list">

					<table class="propertyTable">
						
						<#-- Project State -->
						<#if projectStateProp?has_content>
							<#assign projectState = projectStateProp.firstValue!>
							<tr>
								<td class="keyCol">
									Project State
								</td>
								<td class="valueCol">
									<@p.objectProperty projectStateProp editable />
								</td>
							</tr>
						</#if>
						
						<#-- Dates -->
						<#if dateTimeInterval?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Start/End Date
								</td>
								<td class="valueCol">
									<@p.objectProperty dateTimeInterval editable />
								</td>
							</tr>
							
						</#if>   
						
						<#-- Affiliation -->
						<#if relatedAgent?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Affiliation
								</td>
								<td class="valueCol">
									<@p.objectProperty relatedAgent editable />
								</td>
							</tr>
						</#if> 
						
					    <#-- weblinks -->
						<#if weblinks?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Links
								</td>
								<td class="valueCol">
									<@p.objectProperty weblinks editable />
								</td>
							</tr>
							
						</#if>   

						<#-- arc_project_id -->
						<#if arc_project_idProp?has_content>
							<#assign arc_project_id = arc_project_idProp.firstValue!>
							<tr>
								<td class="keyCol">
									ARC Project ID
								</td>
								<td class="valueCol">
									${arc_project_id!}
								</td>
							</tr>
						</#if>
						
						<#-- nhmrc -->
						<#if nhmrc_project_id?has_content>
							<#assign nhmrc_project_id = nhmrc_project_idProp.firstValue!>
							<tr>
								<td class="keyCol">
									NHMRC Project ID
								</td>
								<td class="valueCol">
									${nhmrc_project_id!}
								</td>
							</tr>
						</#if>
						
						<#-- Funded By -->
						<#if fundedBy?has_content>
							<tr>
								<td class="keyCol">
									Funded By
								</td>
								<td class="valueCol">
									<@p.objectProperty fundedBy editable />
								</td>
							</tr>
						</#if>

						<#-- Research Areas -->
						<#if subjectAreas?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<tr>
								<td class="keyCol">
									Research Area(s)
								</td>
								<td class="valueCol">
									<@p.objectProperty subjectAreas editable />
								</td>
							</tr>
							
						</#if>   

				</table>
			</ul>
		</article>
	</section>


	<#-- Investigators -->
	<#if relatedRole?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<article class="sidebar-list property" role="article">
		<h3>
			Investigators
		</h3>
		<ul class="property-list">
			<@p.objectProperty relatedRole editable />
		</ul>
	</article>
	</#if> 

</div>


