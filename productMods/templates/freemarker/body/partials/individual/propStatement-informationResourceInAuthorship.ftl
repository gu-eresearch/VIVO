<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#informationResourceInAuthorship. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->

<#import "lib-sequence.ftl" as s>

<@showAuthorship statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showAuthorship statement>
    <#if statement.person??>
        <#if statement.hasProfile??>
            <#if statement.hasProfile?number = 1>
                <a itemprop="url" rel="author" href="${profileUrl(statement.person)}"><span itemprop="author">${statement.personName}</span></a>
            <#else>
                <span itemprop="author">${statement.personName}</span>
            </#if>
        <#else>
            <span itemprop="author">${statement.personName}</span>
        </#if>
    <#else>
        <#-- This shouldn't happen, but we must provide for it -->
        <a href="${profileUrl(statement.authorship)}">missing author</a>
    </#if>
</#macro>