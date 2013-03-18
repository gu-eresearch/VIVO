<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">
<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">


<div id="breadcrumbs" itemprop="breadcrumb">
	<ul>
	<li><a itemprop="url" href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a itemprop="url" href="${urls.base}/researchers">Researchers</a>&nbsp;&nbsp;&raquo;</li>
	<li>
	<#if (title?length > 140)>
		<span>${title?substring(0, 139)}</span><span> ...</span>
		
	<#else>
		${title}
	</#if>

	</li>
	</ul>
	
	<span style="padding:5px 0px;font-size:12px;float:right;margin-top:-26px;z-index:1001;position:relative;">   
		<a href="javascript:void(0)" id="display-tooltips"><img src="/images/infoIcon.png" alt="tooltip" style="margin-right:5px;vertical-align:middle;"/>Show Tooltips</a> &nbsp;|&nbsp; <a href="javascript:void(0)" id="hide-tooltips">Hide</a>
	</span>
</div>

<span itemscope itemtype="http://schema.org/Person">
<section id="individual-intro" class="vcard person" role="region">
<span itemprop="affiliation" class="org" style="display:none">Griffith University</span>
		<#-- Image -->           
		<#assign individualImage>
			<@p.image individual=individual 
					  propertyGroups=propertyGroups 
					  namespaces=namespaces 
					  editable=editable 
					  showPlaceholder="always" 
					  placeholder="${urls.images}/placeholders/person.thumbnail.jpg" />
		</#assign>

		<#if ( individualImage?contains('<img class="individual-photo"') )>
			<#assign infoClass = 'class="withThumb"'/>
		</#if>
		<#global inTopSection = "1" >
		
		<!-- ************   START REMOVING PUBLIC PROPERTIES THAT WE DONT WANT TO BE DISPLAYED ON TEMPLATE -->
		<#assign hiddenProp = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/familyName")!>
		<#assign hiddenProp = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/fundedBy")!>
		 <!-- ************   START REMOVING PUBLIC PROPERTIES THAT WE DONT WANT TO BE DISPLAYED ON TEMPLATE -->
			   
		<!-- ************   NEW STRUCTURE START  -->
		
		<div id="topSectioMainWrapper">
			<div id="topSectionPhotoWrapper" class="float">
				<div id="photo-wrapper">${individualImage}</div>
			</div><!--end topSectionPhotoWrapper -->
			
			<div id="topSectionDetailsWrapper" class="float">
				<#if relatedSubject??>
					<h2>${relatedSubject.relatingPredicateDomainPublic} for ${relatedSubject.name}</h2>
					<p><a href="${relatedSubject.url}">&larr; return to ${relatedSubject.name}</a></p>
				<#else>                
					<h1 class="foaf-person">
						
						<#-- Moniker / Preferred Title -->
						<#-- Use Preferred Title over Moniker if it is populated -->
						<#assign thetitle = propertyGroups.pullProperty("http://xmlns.com/foaf/0.1/title")!>
						<#assign preferredTitle = propertyGroups.pullProperty("${core}preferredTitle")!>
						<#assign preferredName = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/preferredName")!>
						
						<#if preferredTitle?has_content>
							<#list preferredTitle.statements as statement>
								<div class="preferred-title">
								<span itemprop="jobTitle" class="title"><span itemprop="honorificPrefix" class="honorific-prefix">${statement.value}</span></span>
								<@p.editingLinks "${preferredTitle.name}" statement editable />
								</div>
							</#list>
							<#if preferredTitle.statements?size??>
								<#if preferredTitle.statements?size = 0>
									<#if editable>
										<div class="preferred-title">Add Preferred Title <a href="${preferredTitle.addUrl!}"><img class="add-individual" src="${urls.images}/individual/addIcon.gif" alt="add" title="add preferred title" /></a></div>
									</#if>
								</#if>
							</#if>
						
						<#elseif thetitle?has_content>
							<#list thetitle.statements as statement>
								<div class="preferred-title">
								${statement.value}
								<@p.editingLinks "${thetitle.name}" statement editable />
								</div>
							</#list>
							
						</#if>
						
						<#-- Label -->
						<span class="fn" itemprop="name">
							<@p.labelNoEdit individual editable />
						</span>
						
						<#assign positions = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/hasPrimaryAffiliationRole")!>
						<#if positions?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<@p.objectProperty positions editable />
						</#if> 
						
					</h1>
					
					<span class="allAbbr">
					
						<#-- Generate abbreviated quals -->
						<#assign generatedQuals = propertyGroups.getProperty("${core}educationalTraining")!> 
						<#if generatedQuals?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
							<#if generatedQuals.statements?has_content> <#-- if there are any statements -->
								<span class="hardAbbr">
									<#list generatedQuals.statements as statement>
										<#if statement.degreeAbbr??>
											<span>${statement.degreeAbbr} </span>
										</#if>
									</#list>
								</span>	
							</#if>
						</#if> 
						
						<#assign abbrProp = propertyGroups.pullProperty("http://griffith.edu.au/ontology/hubextensions/qualificationAbbreviation")!>
						<#if abbrProp?has_content>
							<#assign abbr = abbrProp.firstValue!>
							<span class="softAbbr">${abbr!}</span>
						</#if>
					</span>
				</#if>
			</div><!--end topSectionDetailsWrapper -->
			<span class="separator float"></span>
			
			<div id="topSectionEmailPhoneWrapper" class="float">
				<#-- Email -->    
				<#assign email = propertyGroups.pullProperty("${core}email")!>      
				<#if email?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					
					<#if email.statements?has_content> <#-- if there are any statements -->
						<ul id="individual-email" role="list">
							<#list email.statements as statement>
								<li role="listitem">
									<#if statement.value?has_content>
										<#assign alphaloc = statement.value?index_of("@")>
										<a class="email" href="mailto:${statement.value}"><span itemprop="email">${statement.value}</span></a>
										<@p.addLink email editable />
										<@p.editingLinks "${email.localName}" statement editable />
									</#if>
								</li>
							</#list>
						</ul>
					</#if>
				</#if>
				  
				<#-- Phone --> 
				<#assign phone = propertyGroups.pullProperty("${core}phoneNumber")!>
				<#if phone?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					
					<#if phone.statements?has_content> <#-- if there are any statements -->
						<ul id="individual-phone" role="list">
							<#list phone.statements as statement>
								<li role="listitem">
									<#if statement.value?has_content>
										<#assign replaced = statement.value?replace("-"," ")>
										${replaced?substring(4)}
										<@p.addLink phone editable />
										<@p.editingLinks "${phone.localName}" statement editable />
									</#if>	
								</li>
							</#list>
						</ul>
					</#if>
				</#if>   
			</div><!--end topSectionEmailPhoneWrapper -->
			<span class="separator float"></span>
			
			<div id="topSectionAddressWrapper" class="float">
				 <#-- Address -->
				<ul id="individual-address" role="list">
				<#assign address = propertyGroups.pullProperty("${core}mailingAddress")!>
				<#if address?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
					<span itemprop="contactPoint" class="adr street-address">
					<@p.objectProperty address editable />
					</span>
				</#if> 
				</ul>
			</div><!--end topSectionAddressWrapper -->
		
		</div><!--end topSectioMainWrapper -->
		<#global inTopSection = "0" >
		<!-- ************    NEW STRUCTURE END  -->

</section>
 <#if individual.showAdminPanel>
	 <#include "individual-adminPanel.ftl"> 
</#if>

<#include "individual-profileInfoPanel.ftl"> 

<#assign nameForOtherGroup = "other"> <#-- used by both individual-propertyGroupMenu.ftl and individual-properties.ftl -->

<#-- Property group menu -->
<#include "individual-propertyGroupMenu.ftl">

<#-- Ontology properties -->
<#include "individual-properties.ftl">

</span> <#-- End itemscope Person -->
