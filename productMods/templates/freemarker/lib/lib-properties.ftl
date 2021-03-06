<#--
Copyright (c) 2012, Cornell University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of Cornell University nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
-->

<#-----------------------------------------------------------------------------
    Macros and functions for working with properties and property lists
------------------------------------------------------------------------------>

<#-- Return true iff there are statements for this property -->
<#function hasStatements propertyGroups propertyName>

    <#local property = propertyGroups.getProperty(propertyName)!>
    
    <#-- First ensure that the property is defined
    (an unpopulated property while logged out is undefined) -->
    <#if ! property?has_content>
        <#return false>
    </#if>
    
    <#if property.collatedBySubclass!false> <#-- collated object property-->
        <#return property.subclasses?has_content>
    <#else>
        <#return property.statements?has_content> <#-- data property or uncollated object property -->
    </#if>
</#function>


<#-----------------------------------------------------------------------------
    Macros for generating property lists
------------------------------------------------------------------------------>

<#macro dataPropertyListing property editable>
    <#if property?has_content> <#-- true when the property is in the list, even if not populated (when editing) -->
        <@addLinkWithLabel property editable />
        <@dataPropertyList property editable />
    </#if>
</#macro>

<#macro dataPropertyList property editable>
    <#list property.statements as statement>
        <@propertyListItem property statement editable >${statement.value}</@propertyListItem>
    </#list> 
</#macro>

<#macro objectProperty property editable template=property.template>
    <#if property.collatedBySubclass?has_content> 
        <#if property.collatedBySubclass> <#-- collated -->
            <#if property.localName = "relatedRole">
                <@objectPropertyListNoDupeForRole property editable property.statements template />
            <#else>
                <@collatedObjectPropertyList property editable template />
            </#if>    
        </#if>
    <#else> <#-- uncollated -->
        <#-- We pass property.statements and property.template even though we are also
             passing property, because objectPropertyList can get other values, and
             doesn't necessarily use property.statements and property.template -->
         
         <#if property.localName = "hasSubjectArea">
            <@p.researchAreaTreeList property editable />
          <#elseif property.localName = "relatedRole">
            <@objectPropertyListNoDupeForRole property editable property.statements template />
          <#elseif property.localName = "hasResearchArea">
            <@objectPropertyListNoEditLinks property editable property.statements template />
          <#elseif property.localName = "webpage">
            <@objectPropertyListNoEditLinks property editable property.statements template />   
        <#else>
            <@objectPropertyList property editable property.statements template />
        </#if>    
        
    </#if>
</#macro>

<#macro collatedObjectPropertyList property editable template=property.template >
    
    <#local subclasses = property.subclasses>
    <#list subclasses as subclass>
        <#local subclassName = subclass.name!>
            
        <#if subclassName?has_content>
            <li class="subclass" role="listitem">
                <h3>${subclassName?lower_case} </h3>
                <ul class="subclass-property-list">
                    <@objectPropertyList property editable subclass.statements template />
                </ul>
            </li>
        <#else>
            <#-- If not in a real subclass, the statements are in a dummy subclass with an
                 empty name. List them in the top level ul, not nested. -->
            <@objectPropertyList property editable subclass.statements template/>
        </#if>
    </#list>
</#macro>

<#-- Full object property listing, including heading and ul wrapper element. 
Assumes property is non-null. -->
<#macro objectPropertyListing property editable template=property.template>
    <#local localName = property.localName>
    
    <h2 id="${localName}">${property.name?capitalize} <@addLink property editable /> <@verboseDisplay property /></h2>    

    
    <ul id="individual-${localName}" role="list">
        <@objectProperty property editable />
    </ul>
</#macro>

<#macro objectPropertyList property editable statements=property.statements template=property.template>
    <#list statements as statement>
        <@propertyListItem property statement editable><#include "${template}"></@propertyListItem>
    </#list>
</#macro>

<#macro objectPropertyListNoEditLinks property editable statements=property.statements template=property.template>
    <#list statements as statement>
        <@propertyListItemNoEditLinks property statement editable><#include "${template}"></@propertyListItemNoEditLinks>
    </#list>
</#macro>

<#macro objectPropertyListNoDupeForRole property editable statements=property.statements template=property.template>
    <#if inGroupTemplate??>
        <#local localName = property.localName>
        <h2 id="${localName!}">${property.name?capitalize}</h2>    
    </#if>
    <#local localName = property.localName>
    
    <ul id="individual-${localName}" class="list-columns" role="list">
    <#assign lastIndividual = ""/>
    <#list statements as statement>
        <#if lastIndividual != statement.indivInRole!>
            <@propertyListItem property statement editable><#include "${template}"></@propertyListItem>
        <#else> 
        </#if>
        <#assign lastIndividual = statement.indivInRole!/>
    </#list>
    </ul>
</#macro>

<#-- Some properties usually display without a label. But if there's an add link, 
we need to also show the property label. If no label is specified, the property
name will be used as the label. -->
<#macro addLinkWithLabel property editable label="${property.name?capitalize}" extraParams="">
    <#local addLink><@addLink property editable label extraParams /></#local>
    <#local verboseDisplay><@verboseDisplay property /></#local>
    <#-- Changed to display the label when user is in edit mode, even if there's no add link (due to 
    displayLimitAnnot, for example). Otherwise the display looks odd, since neighboring 
    properties have labels. 
    <#if addLink?has_content || verboseDisplay?has_content>
        <h2 id="${property.localName}">${label} ${addLink!} ${verboseDisplay!}</h2>         
    </#if>
    -->
    <#if editable> 
        <h2 id="${property.localName}">${label} ${addLink!} ${verboseDisplay!}</h2>         
    </#if>
</#macro>

<#macro addLink property editable label="${property.name}" extraParams="">
    <#if editable>
        <#local url = property.addUrl>
        <#if url?has_content>
            <@showAddLink property.localName label addParamsToEditUrl(url, extraParams) />
        </#if>
    </#if>
</#macro>

<#macro addEditLink property editable label="${property.name}" extraParams="">
    <#if editable>
        <#local url = property.addUrl>
        <#if url?has_content>
            <@showAddEditLink property.localName label addParamsToEditUrl(url, extraParams) />
        </#if>
    </#if>
</#macro>

<#function addParamsToEditUrl url extraParams="">
    <#if extraParams?is_hash_ex>
        <#list extraParams?keys as key>
            <#local url = "${url}&${key}=${extraParams[key]?url}">
        </#list>
    </#if>
    <#return url>
</#function>

<#macro showAddLink propertyLocalName label url>
    <a class="addEditDeleteLink add-${propertyLocalName}" href="${url}" title="Add new ${label?lower_case} entry"><img class="add-individual" src="${urls.images}/individual/addIcon.gif" alt="add" /></a>
</#macro>

<#macro showAddEditLink propertyLocalName label url>
    <a class="addEditDeleteLink add-${propertyLocalName}" href="${url}" title="Add / Edit ${label?lower_case} entries"><img class="add-individual" src="${urls.images}/individual/addIcon.gif" alt="add" /><img class="add-individual" src="${urls.images}/individual/editIcon.gif" alt="add" /></a>
</#macro>

<#macro propertyLabel property label="${property.name?capitalize}">
    <h2 id="${property.localName}">${label} <@verboseDisplay property /></h2>     
</#macro>


<#macro propertyListItem property statement editable >
    <li role="listitem" class="dataprop_text">    
        <@editingLinks "${property.localName}" statement editable/>
        <#nested>        
    </li>
</#macro>

<#macro propertyListItemNoEditLinks property statement editable >
    <li role="listitem" class="dataprop_text">    
        <#nested>        
    </li>
</#macro>

<#macro editingLinks propertyLocalName statement editable extraParams="">
    <#if editable>
        <div class='edit-icons'>
            <@editLink propertyLocalName statement extraParams />
            <@deleteLink propertyLocalName statement extraParams />
        </div>
    </#if>
</#macro>

<#macro editLink propertyLocalName statement extraParams="">
    <#local url = statement.editUrl>
    <#if url?has_content>
        <@showEditLink propertyLocalName addParamsToEditUrl(url, extraParams) />
    </#if>
</#macro>

<#macro showEditLink propertyLocalName url>
    <a class="addEditDeleteLink edit-${propertyLocalName}" href="${url}" title="edit this entry"><img class="edit-individual" src="${urls.images}/individual/editIcon.gif" alt="edit" /></a>
</#macro>

<#macro deleteLink propertyLocalName statement extraParams=""> 
    <#local url = statement.deleteUrl>
    <#if url?has_content>
        <@showDeleteLink propertyLocalName addParamsToEditUrl(url, extraParams) />
    </#if>
</#macro>

<#macro showDeleteLink propertyLocalName url>
    <a class="addEditDeleteLink delete-${propertyLocalName}" href="${url}" title="delete this entry"><img  class="delete-individual" src="${urls.images}/individual/deleteIcon.gif" alt="delete" /></a>
</#macro>

<#macro verboseDisplay property>
    <#local verboseDisplay = property.verboseDisplay!>
    <#if verboseDisplay?has_content>       
        <section class="verbosePropertyListing">
            <a class="propertyLink" href="${verboseDisplay.propertyEditUrl}" title="name">${verboseDisplay.localName}</a> 
            (<span>${property.type?lower_case}</span> property);
            order in group: <span>${verboseDisplay.displayRank};</span> 
            display level: <span>${verboseDisplay.displayLevel};</span>
            update level: <span>${verboseDisplay.updateLevel}</span>
        </section>
    </#if>
</#macro>

<#-----------------------------------------------------------------------------
    Macros for specific properties
------------------------------------------------------------------------------>

<#-- Image 

     Values for showPlaceholder: "always", "never", "with_add_link" 
     
     Note that this macro has a side-effect in the call to propertyGroups.pullProperty().
-->
<#macro image individual propertyGroups namespaces editable showPlaceholder="never" placeholder="">
    <#local mainImage = propertyGroups.pullProperty("${namespaces.vitroPublic}mainImage")!>
    <#local extraParams = "">
    <#if placeholder?has_content>
        <#local extraParams = { "placeholder" : placeholder } >
    </#if>
    <#local thumbUrl = individual.thumbUrl!>
    <#-- Don't assume that if the mainImage property is populated, there is a thumbnail image (though that is the general case).
         If there's a mainImage statement but no thumbnail image, treat it as if there is no image. -->
    <#if (mainImage.statements)?has_content && thumbUrl?has_content>
        <#--<a href="${individual.imageUrl}" title="individual photo"><img class="individual-photo" src="${thumbUrl}" title="click to view larger image" alt="${individual.name}" width="160" /></a>-->
        <img itemprop="image" class="individual-photo photo" src="${thumbUrl}" title="profile image" alt="${individual.name}" width="160" />
        <@editingLinks "${mainImage.localName}" mainImage.first() editable extraParams />
    <#else>
        <#local imageLabel><@addLinkWithLabel mainImage editable "Photo" extraParams /></#local>
        ${imageLabel}
        <#if placeholder?has_content>
            <#if showPlaceholder == "always" || (showPlaceholder="with_add_link" && imageLabel?has_content)>
                <img itemprop="image" class="individual-photo" src="${placeholder}" title = "no image" alt="placeholder image" width="160" />
            </#if>
        </#if>
    </#if>
</#macro>

<#-- Label -->
<#macro label individual editable labelCount>
    <#local label = individual.nameStatement>
    ${label.value}
    <#if (labelCount > 1)  && editable >
        <span class="inline">
            <a id="manageLabels" href="${urls.base}/manageLabels?subjectUri=${individual.uri!}" style="margin-left:20px;font-size:0.7em">
                manage labels
            </a>
        </span>
    <#else>
        <@editingLinks "label" label editable />
    </#if>
</#macro>

<#macro labelNoEdit individual editable>
    <#local label = individual.nameStatement>
    ${label.value}
</#macro>

<#-- Most specific types -->
<#macro mostSpecificTypes individual>
    <#list individual.mostSpecificTypes as type>
        <span class="display-title">${type}</span>
    </#list>
</#macro>

<#--Property group names may have spaces in them, replace spaces with underscores for html id/hash-->
<#function createPropertyGroupHtmlId propertyGroupName>
    <#return propertyGroupName?replace(" ", "_")>
</#function>




<#macro groupedObjectPropertyList property editable statements=property.statements template=property.template>
<#assign currentSubClass = "" >
     <#assign counter = 0 >
    <#list statements as statement>
        <#if statement.subclass??>
            
            <#if statement.subclass == currentSubClass >
            <#else>
                <#if statement.subclassLabel??>
                    <#if (counter > 0) >
                        </ul>
                        </li>
                    </#if>
                    <li class="subclass" role="listitem">   
                    <h3>${statement.subclassLabel} </h3>
                    <ul class="subclass-property-list">
                <#else>
                    <#if  (counter > 0) >
                        </ul>
                        <li>
                    </#if>  
                    <li class="subclass" role="listitem">
                    <h3>Other</h3>
                    <ul class="subclass-property-list">
                </#if>
            </#if>
            <#assign currentSubClass = statement.subclass>
        </#if>
        <#assign counter = (counter+1) >
        <@propertyListItem property statement editable><#include "${template}"></@propertyListItem>
        
    </#list>
    </ul>
    </li>
</#macro>



<#macro publicationObjectPropertyList property editable statements=property.statements template=property.template>
<#assign startedOther = "false" >
<#assign currentSubClass = "" >
     <#assign counter = 0 >
    <#list statements as statement>
        <#if statement.subclass??>
            <#if statement.subclass == 'http://purl.org/ontology/bibo/AcademicArticle' || 
                 statement.subclass == 'http://purl.org/ontology/bibo/Book' || 
                 statement.subclass == 'http://purl.org/ontology/bibo/Chapter' || 
                 statement.subclass == 'http://vivoweb.org/ontology/core#ConferencePaper' || 
                 statement.subclass == 'http://griffith.edu.au/ontology/hubextensions/CreativeWork' >
            <#else> 
                <#if startedOther == "false">
                    </ul>
                    </li>
                    <li class="subclass" role="listitem">   
                    <h3>Other</h3>
                    <#assign startedOther = "true" >
                    <ul class="subclass-property-list">
                <#else>
                </#if>
                
            </#if>
            
            <#if statement.subclass == currentSubClass >
            <#else>
                <#if statement.subclassLabel??>
                    <#if (counter > 0) && startedOther == "false" >
                        </ul>
                        </li>
                    </#if>
                    <#if startedOther == "false">
                    <li class="subclass" role="listitem">
                    <#assign isPluralLabel = "s" >
                    <#if statement.subclassLabel?ends_with("s")>
                        <#assign isPluralLabel = "" >
                    </#if>
                        <h3>${statement.subclassLabel}${isPluralLabel}</h3>
                    <ul class="subclass-property-list">
                    </#if>
                <#else>
                    
                </#if>
            </#if>
            <#assign currentSubClass = statement.subclass>
        </#if>
        <#assign counter = (counter+1) >
        <@propertyListItem property statement editable><#include "${template}"></@propertyListItem>
        
    </#list>
    </ul>
    </li>
</#macro>


<#macro researchAreaTreeList property editable statements=property.statements template=property.template>
<#assign currentSubClass = "" >
     <#assign counter = 0 >
    <#list statements as statement>

        <#if statement.for4??>
            <#if statement.for4 == currentSubClass >
            <#else>
                <#if (counter > 0) >
                    </ul>
                    </li>
                </#if>          
                <li <#if statement.for6??> class="FOR4item" <#else> class="FOR4item selectedFOR" </#if>>${statement.for4!} 
                    <#if statement.for6??><#else>  </#if>
                <#assign counter = 0 >
            </#if>
            
            <#if statement.for6??>
                <#if (counter == 0) >
                    <ul class="FOR6List">
                </#if>  
                <li class="selectedFOR"> - ${statement.for6!} 
                <#switch statement.prop>
                  <#case "http://purl.org/asc/1297.0/2008/for/FOR">
                     <#--<span><img border="0" src="/themes/gu/images/icon_code_for.png" alt="FOR code icon" title="Field Of Research Code" /></span>-->
                     <#break>
                  <#case "http://purl.org/asc/1297.0/1998/rfcd/RFCD">
                     <span><img border="0" src="/themes/gu/images/icon_code_rfcd.png" alt="RFCD code icon" title="RFCD Code" /></span>
                     <#break>
                  <#case "http://purl.org/asc/1297.0/1998/seo/SEO">
                     <span><img border="0" src="/themes/gu/images/icon_code_seo.png" alt="SEO code icon" title="Socio Econimic Objective Code" /></span>
                     <#break>
                  <#default>
                     
                </#switch>  
                 </li>
                <#assign counter = (counter+1) >
            </#if>
            <#assign currentSubClass = statement.for4>      
        </#if>
        
    </#list>
    <#if (counter > 0) >
        </ul>
    </#if>  
    </li>
</#macro>
