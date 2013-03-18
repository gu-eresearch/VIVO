<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#awardOrHonor -->

<#import "lib-sequence.ftl" as s>
<#import "lib-datetime.ftl" as dt>

<@showAward statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showAward statement>
    
    <#local linkedIndividual>
        <#if statement.award??>
            ${statement.awardTitle}
        <#else>
            <#-- This shouldn't happen, but we must provide for it -->
            missing award
        </#if>
    </#local>
    
    


    
    <@s.join [ linkedIndividual ] /> <@dt.yearSpan statement.dateTimeStart! />

</#macro>