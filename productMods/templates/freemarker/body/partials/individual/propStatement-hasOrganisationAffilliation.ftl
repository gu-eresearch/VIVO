<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#hasRole and its child properties.
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-sequence.ftl" as s>
<#import "lib-datetime.ftl" as dt>

<@showRole statement />



<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showRole statement>
	<#local core = "http://vivoweb.org/ontology/core#">
	<#local guhubext = "http://griffith.edu.au/ontology/hubextensions/">
	

    <#local linkedIndividual>
        
        <#if statement.object??>
        	<#if statement.name??>
				<#if statement.isProfiledGroup?number = 1>
					<a href="${profileUrl(statement.object)}">${statement.name!}</a>
				<#else>
					${statement.name!}
				</#if>
				
			<#else>
				<#-- This shouldn't happen, but we must provide for it -->
				<a href="${profileUrl(statement.role)}">missing activity</a>
			</#if>
        </#if>
    </#local>

    ${linkedIndividual} 


</#macro>



