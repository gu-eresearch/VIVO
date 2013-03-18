<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">
<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">


<div id="breadcrumbs">
	<ul>
	<li><a href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li>Funding Organisations&nbsp;&nbsp;&raquo;</li>
	<li>${title}</li>
	</ul>
</div>
    
<section id="individual-intro" class="vcard person" role="region">

        <#-- Image -->           
        <#assign individualImage>
            <@p.image individual=individual 
                      propertyGroups=propertyGroups 
                      namespaces=namespaces 
                      editable=editable 
                      showPlaceholder="with_add_link" 
                      placeholder="${urls.images}/placeholders/non.person.thumbnail.jpg" />
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
			
			<div id="topSectionDetailsWrapper" class="float short">
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
			
			
			<#-- Email -->    
			<#assign email = propertyGroups.pullProperty("${core}email")!>   
			<#-- Phone --> 
			<#assign phone = propertyGroups.pullProperty("${core}phoneNumber")!>
			
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
			
			
			 <#-- Address -->
			<#assign address = propertyGroups.pullProperty("${core}mailingAddress")!>
			<#if address?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
				<div id="topSectionAddressWrapper" class="float short">
					<ul id="individual-address" role="list">
						<@p.addLinkWithLabel address editable />
						<@p.objectProperty address editable />
						</ul>
				</div><!--end topSectionAddressWrapper -->		
			</#if> 
		
        
        </div><!--end topSectioMainWrapper -->
        <#global inTopSection = "0" >
        <!-- ************    NEW STRUCTURE END  -->

</section>

<#if individual.showAdminPanel>
	<#include "individual-adminPanel.ftl">
</#if>


<#-- overview -->
<#assign overview = propertyGroups.pullProperty("${core}overview")!>
<#if overview?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<h3>Overview</h3>
	<@p.addLinkWithLabel overview editable />
	<#list overview.statements as statement>
		<div class="individual-overview">
			<div class="overview-value">
				${statement.value}
			</div>
			<@p.editingLinks "${overview.localName}" statement editable />
		</div>
	</#list>
</#if>



<#assign nameForOtherGroup = "other"> <#-- used by both individual-propertyGroupMenu.ftl and individual-properties.ftl -->
<table class="propertyTable">


<#-- distributesFundingFrom -->
<#assign distributesFundingFrom = propertyGroups.pullProperty("${core}distributesFundingFrom")!> 
<#if distributesFundingFrom?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<tr>
		<td class="keyCol">
			Distributes Funding From
		</td>
		<td class="valueCol">
			<@p.objectProperty distributesFundingFrom editable />
		</td>
	</tr>
	
</#if>   


<#-- Awards Grant -->
<#assign awardsGrant = propertyGroups.pullProperty("${core}awardsGrant")!> 
<#if awardsGrant?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<tr>
		<td class="keyCol">
			Awards Grant
		</td>
		<td class="valueCol">
			<@p.objectProperty awardsGrant editable />
		</td>
	</tr>
	
</#if>   

 <#-- Provides Funding Through -->
<#assign providesFundingThrough = propertyGroups.pullProperty("${core}providesFundingThrough")!> 
<#if providesFundingThrough?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
	<tr>
		<td class="keyCol">
			Provides Funding Through
		</td>
		<td class="valueCol">
			<@p.objectProperty providesFundingThrough editable />
		</td>
	</tr>
	
</#if>   
</table>
