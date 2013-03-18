<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#hasRole and its child properties.
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-datetime.ftl" as dt>

<@showRole statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showRole statement>
   <#local core = "http://vivoweb.org/ontology/core#">
	<#local guhubext = "http://griffith.edu.au/ontology/hubextensions/">
	
		
	
	
	
    <#local linkedIndividual>
        
        <#if statement.activity??>
            <#switch statement.property>
			  <#case "${core}hasPrincipalInvestigatorRole">
				 <a href="${profileUrl(statement.activity)}">${statement.activityLabel!statement.activityName}</a>
				 <#break>
			  <#case "${core}hasInvestigatorRole">
				 <a href="${profileUrl(statement.activity)}">${statement.activityLabel!statement.activityName}</a>
				 <#break>
			  <#case "${core}hasCo-PrincipalInvestigatorRole">
				 <a href="${profileUrl(statement.activity)}">${statement.activityLabel!statement.activityName}</a>
				 <#break>
			  <#case "${core}hasMemberRole">
				 <a href="${profileUrl(statement.activity)}">${statement.activityLabel!statement.activityName}</a>
				 <#break>
			  <#case "http://griffith.edu.au/ontology/hubextensions/hasPrimaryAffiliationRole">
			  	 <a href="${profileUrl(statement.activity)}">${statement.activityLabel!statement.activityName}</a>
				 <#break>	 
			  <#default>
				 ${statement.activityLabel!statement.activityName}
			</#switch>  
            
        <#else>
            <#-- This shouldn't happen, but we must provide for it -->
            <a href="${profileUrl(statement.role)}">missing activity</a>
        </#if>
    </#local>
    
    
    <#local dateTime>
        <#if statement.property == "${core}hasPrincipalInvestigatorRole">
            <@dt.yearSpan statement.dateTimeStart! />
        <#else>
            <@dt.yearIntervalSpan "${statement.dateTimeStart!}" "${statement.dateTimeEnd!}" />
        </#if>
    </#local>
    
    
    

    

	<#switch statement.property>
	  <#case "${guhubext}hasRHDSupervisorRole">
		 ${statement.roleLabel!}, ${linkedIndividual} ${dateTime!}		 
	  <#break>
	  <#case "${guhubext}hasHonoursSupervisorRole">
		${statement.roleLabel!}, ${linkedIndividual} ${dateTime!}		 
	  <#break>
	  <#case "${core}hasMemberRole">
		${statement.roleLabel!} ${linkedIndividual} ${dateTime!}		 
	  <#break>
	  <#case "${guhubext}hasPrimaryAffiliationRole">
		${statement.roleLabel!} ${linkedIndividual} ${dateTime!}		 
	  <#break>
	  
	  <#default>
			${linkedIndividual}, ${statement.roleLabel!} ${dateTime!}
			<br />
			<span class="roleDescription">
			${statement.roleDesc!}
			</span>
	</#switch>  
	
	


</#macro>