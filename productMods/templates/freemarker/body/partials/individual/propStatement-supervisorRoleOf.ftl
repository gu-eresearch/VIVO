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
        
        <#if statement.supervisor??>
        	<#if statement.hasProfile??>
				<#if statement.hasProfile?number = 1>
					<a href="${profileUrl(statement.supervisor)}">${statement.supervisorName!}</a>
				<#else>
					${statement.supervisorName!}
				</#if>
			</#if>
			
        <#else>
            <#-- This shouldn't happen, but we must provide for it -->
            <a href="${profileUrl(statement.role)}">missing supervisor</a>
        </#if>
    </#local>
    
    
    <#local dateTime>
        <@dt.yearIntervalSpan "${statement.dateTimeStart!}" "${statement.dateTimeEnd!}" />
    </#local>

    ${linkedIndividual} ${statement.roleLabel!} ${dateTime!}


</#macro>



