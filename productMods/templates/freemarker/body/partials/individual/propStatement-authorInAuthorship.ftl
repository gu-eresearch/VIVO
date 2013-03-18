<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#authorInAuthorship. 
    
     This template must be self-contained and not rely on other variables set for the individual page, because it
     is also used to generate the property statement during a deletion.  
 -->
 
<#import "lib-sequence.ftl" as s>
<#import "lib-datetime.ftl" as dt>

<@showAuthorship statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showAuthorship statement>
    <#if statement.hideThis?has_content>
        <span class="hideThis">&nbsp;</span>
        <script type="text/javascript" >
            $('span.hideThis').parent().parent().addClass("hideThis");
            if ( $('h3#authorInAuthorship').attr('class').length == 0 ) {
                $('h3#authorInAuthorship').addClass('hiddenPubs');
            }
            $('span.hideThis').parent().remove();
        </script>
    <#else>
        <#local linkedIndividual>
            <#if statement.infoResource??>
                <a itemprop="url" href="${profileUrl(statement.infoResource)}"><span itemprop="name">${statement.infoResourceName}</span></a>
            <#else>
                <#-- This shouldn't happen, but we must provide for it -->
                <a href="${profileUrl(statement.authorship)}">missing information resource</a>
            </#if>
        </#local>
        
        <#local additionalInfo>
        
            <#if statement.journalName??>
                <span><strong> Published in:</strong> ${statement.journalName!} </span>
            </#if>
            <#if statement.issn??>
                <span><strong> ISSN:</strong> ${statement.issn!} </span>
            </#if>
            <#if statement.pageStart??>
                <span><strong> Pages:</strong> ${statement.pageStart!} - ${statement.pageEnd!} </span>
            </#if>
            <#if statement.volume??>
                <span><strong> Volume:</strong> ${statement.volume!} </span>
            </#if>
            
            
        </#local>
        
        <#local researchAreas>
            <#if statement.subjectAreaNames??>
                <#if statement.subjectAreaNames?length  &gt; 1>
                    <span><strong> Research Area(s):</strong>  ${statement.subjectAreaNames!} </span>
                </#if>  
            </#if>
        </#local>
        
        <#local linkedAuthors>
            <#if statement.authorNames??>
                <span><strong> Author(s):</strong>  ${statement.authorNames!} </span>
            </#if>
        </#local>
        
        
        
        <#local govtReportableIcon>
            <#if statement.subclass??>
                <#if statement.subclass == 'http://purl.org/ontology/bibo/AcademicArticle' || 
                     statement.subclass == 'http://purl.org/ontology/bibo/Book' || 
                     statement.subclass == 'http://purl.org/ontology/bibo/Chapter' || 
                     statement.subclass == 'http://vivoweb.org/ontology/core#ConferencePaper' || 
                     statement.subclass == 'http://griffith.edu.au/ontology/hubextensions/CreativeWork' >
                     <span class="dataIcons"><img border="0" src="${urls.base}/themes/gu/images/info_icon.png" alt="help information button" class="publistingInfoImage" title="Australian Government Reportable Research Output"></span>
                <#else>
                     <span class="dataIcons"><img border="0" src="${urls.base}/themes/gu/images/spacer.png" alt="spacer image" ></span>
                </#if>
            </#if>  
        </#local>           

        <span itemscope itemtype="http://schema.org/Article">
            ${govtReportableIcon} ${linkedIndividual} <@dt.yearSpan "${statement.dateTime!}" /> 
            <div class="additionalInfoWrapper">${linkedAuthors}</div>
            <div class="additionalInfoWrapper">${additionalInfo}</div>
            <div class="additionalInfoWrapper">${researchAreas}</div>
        </span>
    </#if>    
</#macro>