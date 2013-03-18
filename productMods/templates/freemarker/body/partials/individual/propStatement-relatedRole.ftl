<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#relatedRole and
     http://vivoweb.org/ontology/core#linkedRole. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-sequence.ftl" as s>
<#import "lib-datetime.ftl" as dt>

<@showRole statement property />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showRole statement property>
    
    <#local linkedIndividual>
        <#if statement.indivInRole??>
            <#if statement.indivLabel??>
                <#if statement.hasProfile??>
                    <#if statement.hasProfile?number = 1>
                        <a href="${profileUrl(statement.indivInRole)}">${statement.indivLabel!statement.indivName}</a>
                    <#else>
                        ${statement.indivLabel!} 
                    </#if>
                <#else>
                    ${statement.indivLabel!}
                </#if>    
            </#if>
        <#else>
            <#-- This shouldn't happen, but we must provide for it -->
            <a href="${profileUrl(statement.role)}">missing person in this role</a>
        </#if>
    </#local>

    <#-- Generally roles are assigned a label when entered through a custom form. Investigator and its subclasses do not,
    so use the type label instead. -->
    <#local roleLabel>
        <#if statement.roleLabel?has_content>${statement.roleLabel}
        <#-- Display, e.g., "Principal Investigator" for "Principal Investigator Role",
                            "Editor" for "Editor Role".
             This information is redundant if the property is collated, since it appears in the subclass label. -->
        <#elseif (! property.collatedBySubclass ) && statement.roleTypeLabel?has_content>${statement.roleTypeLabel?replace(" Role", "")}
        </#if>
    </#local>
    
    <#local theRoleClassLabel>
        <#if statement.roleTypeLabel?has_content>
            <#if statement.roleTypeLabel = "Student Member">student-member    
            <#elseif statement.roleTypeLabel = "External Member">external-member
            <#--<#elseif statement.roleTypeLabel = "Primary Affiliation">primary-aff-member-->
            <#else>member
            </#if>
        </#if>
    </#local>
    <#local theRoleLabel>
        <#if statement.roleTypeLabel?has_content>
            <#if statement.roleTypeLabel = "Student Member">Student Member    
            <#elseif statement.roleTypeLabel = "External Member">External Member
            <#elseif statement.roleTypeLabel = "Primary Affiliation">Member
            <#elseif statement.roleTypeLabel = "Primary Affiliation Role">Member
            <#else>${statement.roleTypeLabel!}
            </#if>
        </#if>
    </#local>
    
    <#if linkedIndividual?has_content>
    ${linkedIndividual} <@dt.yearIntervalSpan "${statement.dateTimeStart!}" "${statement.dateTimeEnd!}" />  <span class="${theRoleClassLabel!}">${theRoleLabel!}</span> 
    </#if>

</#macro>