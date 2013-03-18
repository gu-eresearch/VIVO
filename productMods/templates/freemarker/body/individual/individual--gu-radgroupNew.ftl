<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">

<#global inGroupTemplate = "1" >

<script type="text/javascript">
	var site_url = "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">

<div id="breadcrumbs" itemprop="breadcrumb">
	<ul>
	<li><a itemprop="url" href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a itemprop="url" href="${urls.base}/groups">Groups</a>&nbsp;&nbsp;&raquo;</li>
	<li>
	<#if (title?length > 140)>
		<span>${title?substring(0, 139)}</span><span> ...</span>
		
	<#else>
		${title}
	</#if>

	</li>
	</ul>
</div>
<span itemscope itemtype="http://schema.org/Organization">
<section id="individual-intro" class="vcard org" role="region">
<#-- orgStructure -->
        <#assign orgStructure = propertyGroups.pullProperty("${core}orgStructure")!>
        <#if orgStructure?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
                <ul itemprop="affiliation" class="org" style="display:none">
                        <@p.objectPropertyListing orgStructure editable />
                </ul>
        </#if>
<#-- end orgStructure -->

		<#-- Image -->           
		<#assign individualImage>
			<@p.image individual=individual 
					  propertyGroups=propertyGroups 
					  namespaces=namespaces 
					  editable=editable 
					  showPlaceholder="always"
					  placeholder="${urls.images}/placeholders/group.thumbnail.jpg" />
		</#assign>

		<#if ( individualImage?contains('<img class="individual-photo"') )>
			<#assign infoClass = 'class="withThumb"'/>
		</#if>
		<#global inTopSection = "1" >
		
		
			   
		<!-- ************   NEW STRUCTURE START  -->
		
		<#-- Email -->    
		<#assign email = propertyGroups.pullProperty("${core}email")!>   
		<#-- Phone --> 
		<#assign phone = propertyGroups.pullProperty("${core}phoneNumber")!>
		<#-- Homepage --> 
		<#assign homepage = propertyGroups.pullProperty("${core}webpage")!>
		 <#-- Address -->
		<#assign address = propertyGroups.pullProperty("${core}mailingAddress")!>
			
		<#if email?has_content||phone?has_content||address?has_content>
			<#assign topWrapperId = "topSectionDetailsWrapper" />
			<#assign shortClass = "short" />
		<#else>
			<#assign topWrapperId = "topSectionDetailsWrapper" />
			<#assign shortClass = "" />
		</#if>
		
		
		<div id="topSectioMainWrapper">
			<#--<#if ( individualImage?contains('<img class="individual-photo"') )>-->
				<div id="topSectionPhotoWrapper" class="float">
					<div id="photo-wrapper">${individualImage}</div>
				</div><!--end topSectionPhotoWrapper -->
			<#--</#if>-->
			
			<div id="${topWrapperId}" class="float ${shortClass} non-person-entity">
				<#if relatedSubject??>
					<h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
					<p><a href="${relatedSubject.url}">&larr; return to ${relatedSubject.name}</a></p>
				<#else>                
					<h1 class="fn foaf-person">
						<#-- Label -->
						<@p.label individual editable 0 />
					</h1>
					
				</#if>

				<#if homepage?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					<@p.addLinkWithLabel homepage editable />
					<#if homepage.statements?has_content> <#-- if there are any statements -->
						<ul id="individual-homepage" role="list">
							<@p.objectProperty homepage editable />
						</ul>
					</#if>
				</#if>

			
			
			
			<#--<#if email?has_content||phone?has_content||address?has_content>
				<span class="separator float"></span>
			</#if>-->
			
			<#if email?has_content||phone?has_content>
			<div id="topSectionEmailPhoneWrapper" class="float short">
				
				<#if email?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					<@p.addLinkWithLabel email editable />
					<#if email.statements?has_content> <#-- if there are any statements -->
						<ul id="individual-email" role="list">
							<#list email.statements as statement>
								<li role="listitem">
									<#if statement.value?has_content>
										<a class="email" href="mailto:${statement.value}">${statement.value}</a>
										<@p.editingLinks "${email.localName}" statement editable />
									</#if>
								</li>
							</#list>
						</ul>
					</#if>
				</#if>
				  
				
				<#if phone?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					<@p.addLinkWithLabel phone editable />
					<#if phone.statements?has_content> <#-- if there are any statements -->
						<ul id="individual-phone" role="list">
							<#list phone.statements as statement>
								<li role="listitem">
									<#if statement.value?has_content>
										<#assign replaced = statement.value?replace("-"," ")>
										${replaced?substring(0)}
										<@p.editingLinks "${phone.localName}" statement editable />
									</#if>	
								</li>
							</#list>
						</ul>
					</#if>
				</#if>

				
			 
			</div><!--end topSectionEmailPhoneWrapper -->
			</#if>
			
			
			
			<#if address?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<div id="topSectionAddressWrapper" class="float non-person-entity">
					<ul id="individual-address" role="list">
						<@p.addLinkWithLabel address editable />
						<@p.objectProperty address editable />
						</ul>
				</div><!--end topSectionAddressWrapper -->		
			</#if> 

		</div><!--end topSectionDetailsWrapper -->
		
		</div><!--end topSectioMainWrapper -->
		<#global inTopSection = "0" >
		<!-- ************    NEW STRUCTURE END  -->


</section>

<#if individual.showAdminPanel>
	<#include "individual-adminPanel.ftl">
</#if>

<#assign nameForOtherGroup = "other"> <#-- used by both individual-propertyGroupMenu.ftl and individual-properties.ftl -->

<div class="propertyGroup_tab_wrapper">
	<section class="property-group non-person-entity record">

		<#-- overview -->
		<article class="property" role="article">
			<h3>
				Overview
			</h3>
			<#assign overview = propertyGroups.pullProperty("${core}overview")!>
			<#if overview?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<ul class="property-list" style="padding-bottom:0px;">
					<li role="listitem" class="dataprop_text">
					<@p.addLinkWithLabel overview editable />
						<#list overview.statements as statement>
							<div class="individual-overview">
								<@p.editingLinks "${overview.localName}" statement editable />
								<div class="overview-value">
									${statement.value}
								</div>
							</div>
						</#list>
					</li>
				</ul>
			<#else>
				<ul class="property-list" >
					<li role="listitem" class="dataprop_text">
						<p>No overview is currently available for this group.</p>
					</li>
				</ul>
			</#if>
		</article>

		
		<#-- Projects -->
		<article class="property related-projects" role="article">
			<h3>
				Related Projects
			</h3>
			<#assign projects = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/relatedProject")!> 
			<#if projects?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<ul class="property-list">
					<@p.objectPropertyListing projects editable />
				</ul>
			<#else>
				<ul class="property-list" >
					<li role="listitem" class="dataprop_text">
						<p>No related projects are currently available for this group.</p>
					</li>
				</ul>
			</#if>
		</article>

	</section>

	<#-- Positions -->
	<#assign organizationForPosition = propertyGroups.pullProperty("${core}organizationForPosition")!> 
	<#if organizationForPosition?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<article class="sidebar-list property" role="article">
		<h3>
			Positions
		</h3>
		<ul class="property-list">
			<ul class="subclass-property-list group-positions">
				<@p.objectProperty organizationForPosition editable />
			</ul>
		</ul>
	</article>
	</#if> 
	
	<#-- Researchers -->
	<#assign researchers = propertyGroups.pullProperty("${core}relatedRole")!> 
	<#if researchers?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<article class="sidebar-list property" role="article">
		<h3>
			Related Role
		</h3>
		<ul class="property-list">
			<@p.objectProperty researchers editable />
		</ul>
	</article>
	</#if> 
	
	<#-- hasSubOrganization -->
	<#assign hasSubOrganization = propertyGroups.pullProperty("${core}hasSubOrganization")!> 
	<#if hasSubOrganization?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<article class="sidebar-list property" role="article">
		<h3>
			Sub-Organisations
		</h3>
		<ul class="property-list">
			<@p.objectPropertyListing hasSubOrganization editable />
		</ul>
	</article>	
	</#if> 	
		
	<#-- subOrganizationWithin -->
	<#assign subOrganizationWithin = propertyGroups.pullProperty("${core}subOrganizationWithin")!> 
	<#if subOrganizationWithin?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<article class="sidebar-list property" role="article">
		<h3>
			Organisation Within
		</h3>
		<ul class="property-list" itemprop="affiliation" class="org">
			<@p.objectPropertyListing subOrganizationWithin editable />
		</ul>
	</article>	
	</#if> 

</div>

<#global inGroupTemplate = "0" >
</span> <#-- End itemscope Organisation -->

