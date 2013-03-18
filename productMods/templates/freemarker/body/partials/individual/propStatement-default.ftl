<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Default object property statement template. 
	
	 This template must be self-contained and not rely on other variables set for the individual page, because it
	 is also used to generate the property statement during a deletion.  
 -->
	<#if statement.property??>
		<#if statement.property = "http://griffith.edu.au/ontology/hubextensions/projectstate">
			${statement.label!statement.localName!}
		<#elseif statement.property = "http://griffith.edu.au/ontology/hubextensions/relatedProject">
			<span class="relatedProject">${statement.label!statement.localName!}</span><br/><a href="${profileUrl(statement.object)}" title="Visit Project Record For This Project." class="visitRelatedProject">Visit Project Record &raquo;</a> 
		<#else>
			<a href="${profileUrl(statement.object)}">${statement.label!statement.localName!}</a> 
		</#if>
	<#else>
		<a href="${profileUrl(statement.object)}">${statement.label!statement.localName!}</a> 
	</#if>
	



