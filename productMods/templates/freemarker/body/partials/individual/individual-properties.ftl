<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for property listing on individual profile page -->

<#import "lib-properties.ftl" as p>
<#assign subjectUri = individual.controlPanelUrl()?split("=") >
<#assign nameForOtherGroup = nameForOtherGroup!"other">


<#list propertyGroups.all as group>
	<#assign verbose = (verbosePropertySwitch.currentValue)!false>
	<#assign groupName = group.getName(nameForOtherGroup)>
	<div class="propertyGroup_tab_wrapper">
	
	<#if groupName == "background">   

		<section class="property-group" id="background-properties" role="region">
		<#else>
		<section class="property-group" role="region">	
		</#if>
			<!--
			<nav class="scroll-up" role="navigation">
				<a href="#branding">
					<img src="${urls.images}/individual/scroll-up.gif" alt="scroll to property group menus" />
				</a>
			</nav>
			-->
			<#-- Display the group heading --> 
			<#if groupName?has_content>
				<h2 id="${groupName}" style="display:none;">${groupName?capitalize}</h2>
			</#if>
			
			<#-- List the properties in the group -->
			<#list group.properties as property>
				<article class="property" role="article">
					<#-- Property display name -->
					<#if property.localName == "authorInAuthorship" && editable  >
	                    <h3 id="${property.localName}_heading" class="${groupName}_property">
	                    	<span id="${property.localName}_marker" class="marker"></span>
	                    	${property.name?capitalize} <@p.addLink property editable /> <@p.verboseDisplay property /> 
	                        <a id="managePubLink" class="manageLinks" href="${urls.base}/managePublications?subjectUri=${subjectUri[1]!}" title="manage publications" <#if verbose>style="padding-top:10px"</#if> >
	                            manage publications
	                        </a>
	                    </h3>
	                <#else>
						<h3 id="${property.localName}_heading" class="${groupName}_property">
							<span id="${property.localName}_marker" class="marker"></span>
							${property.name?capitalize} <@p.verboseDisplay property />
							<#if property.type == "data">
								<div class="edit-links"><@p.addLink property editable /></div>
							<#-- object property -->
							<#elseif property.localName = "hasSubjectArea">
								<div class="edit-links"><@p.addEditLink property editable /></div>	
							<#elseif property.localName = "hasResearchArea">
								<div class="edit-links"><@p.addEditLink property editable /></div>
							<#elseif property.localName = "webpage">
								<div class="edit-links"><@p.addEditLink property editable /></div>
							<#else>
								<div class="edit-links"><@p.addLink property editable /></div>		
							</#if>
						</h3>             
					</#if>
					<#-- List the statements for each property -->
					<ul class="property-list propertyList_${groupName}" role="list">
						<#-- data property -->
						<#if property.type == "data">
							<#-- <div class="edit-links"><@p.addLink property editable /></div> -->
							<span id="${property.localName}"><@p.dataPropertyList property editable /></span>
						<#-- object property -->
						<#elseif property.localName = "hasSubjectArea">
							<#-- <div class="edit-links"><@p.addEditLink property editable /></div> -->
							<@p.objectProperty property editable />		
						<#elseif property.localName = "hasResearchArea">
							<#-- <div class="edit-links"><@p.addEditLink property editable /></div> -->
							<div class="researchKeywords"><@p.objectProperty property editable />	</div>
						<#elseif property.localName = "webpage">
							<#-- <div class="edit-links"><@p.addEditLink property editable /></div> -->
							<@p.objectProperty property editable />	
						<#else>
							<#-- <div class="edit-links"><@p.addLink property editable /></div> -->
							<@p.objectProperty property editable />				
						</#if>
	
					</ul>
				</article> <!-- end property -->
			</#list>
		</section> <!-- end property-group -->

		<#if groupName?has_content>
			<#if groupName == "overview">                        
				<div class="propertyGroup_tab_rightcolumn">
					<#include "individual-visualizationFoafPerson.ftl">   
					<div class="propertyGroup_cta_btns">
						<a href="http://www.griffith.edu.au/higher-degrees-research/how-to-apply" target="_blank">
							<div class="side_container"><span class="ggrs_btn side_button"></span></div>
							<span class="propertyGroup_cta_txt">Apply for a research degree today.</span>
						</a>
					</div>
					<div class="propertyGroup_cta_btns">
						<a href="http://www.griffith.edu.au/research/research-excellence" target="_blank">
							<div class="side_container"><span class="res_excellence_btn side_button"></span></div>
							<span class="propertyGroup_cta_txt">Griffith Research Excellence</span>
						</a>
					</div>
					<div class="propertyGroup_cta_btns">
						<a href="http://www.griffith.edu.au/higher-degrees-research" target="_blank">
							<div class="side_container"><span class="res_degrees_btn side_button"></span></div>
							<span class="propertyGroup_cta_txt">Higher Degrees by Research at Griffith</span>
						</a>
					</div>
				</div>
				<script>$("#overview").parent().addClass("propertyGroup_overwrite");</script>
			</#if>
		 </#if>
	</div>
	
</#list>