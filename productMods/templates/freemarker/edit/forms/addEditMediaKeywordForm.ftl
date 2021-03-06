<#--
Copyright (c) 2011, Cornell University
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

<#-- Template for adding/editing guhubext:hasMediaKeyword -->
<#import "lib-vivo-form.ftl" as lvf>

<#assign subjectName=editConfiguration.pageData.subjectName!"an Individual" />

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
    <#assign submissionErrors = editSubmission.validationErrors/>
</#if>

<#--Retrieve variables needed-->
<#assign label = lvf.getFormFieldValue(editSubmission, editConfiguration, "label")/>
<#assign newRank = editConfiguration.pageData.newRank/>

<#if label?has_content>
    <#assign editMode = "edit">
<#else>
    <#assign editMode = "add">
</#if>

<#if editMode == "edit">        
        <#assign titleVerb="Edit media keywords of">        
        <#assign submitButtonText="Save changes">
        <#assign disabledVal="disabled">
<#else>
        <#assign titleVerb="Add Media Keywords for">        
        <#assign submitButtonText="Add Media Keywords">
        <#assign disabledVal=""/>
</#if>

<#assign requiredHint="<span class='requiredHint'> *</span>" />

<h2>${titleVerb} ${subjectName}</h2>

<#if submissionErrors??>
<section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="Error alert icon" />
        <p>       
        <#list submissionErrors?keys as errorFieldName>
            ${errorFieldName}: ${submissionErrors[errorFieldName]}  <br/>           
        </#list>
        </p>
</section>
</#if>    
    
<form class="customForm" action ="${submitUrl}" class="customForm">

   
   
    <label for="anchor">Media Keyword Name</label>
    <input  size="70"  type="text" id="label" name="label" value="${label}" role="input" />

    <#if editMode="add">
        <input type="hidden" name="rank" value="${newRank}" />
    </#if>
    
    <input type="hidden" id="editKey" name="editKey" value="${editConfiguration.editKey}"/>
    <p class="submit">
        <input type="submit" id="submit" value="${submitButtonText}"/><span class="or"> or </span>
        <a class="cancel" href="${editConfiguration.cancelUrl}" title="Cancel">Cancel</a>
    </p>    
</form>

<link rel="stylesheet" href="${urls.base}/edit/forms/css/customForm.css" />

<script type="text/javascript" src="${urls.base}/js/userMenu/userMenuUtils.js"></script>
<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>