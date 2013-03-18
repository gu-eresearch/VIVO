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

<#-- Custom form for managing web pages for individuals -->

<#if (editConfiguration.pageData.webpages?size > 1) >
  <#assign ulClass="class='dd'">
<#else>
  <#assign ulClass="">
</#if>

<#assign baseEditWebpageUrl=editConfiguration.pageData.baseEditWebpageUrl!"baseEditWebpageUrl is undefined">
<#assign deleteWebpageUrl=editConfiguration.pageData.deleteWebpageUrl!"deleteWebpageUrl is undefined">
<#assign showAddFormUrl=editConfiguration.pageData.showAddFormUrl!"showAddFormUrl is undefined">

<#--<#if (editConfiguration.pageData.subjectName??) >
<h2><em>${editConfiguration.pageData.subjectName}</em></h2>
</#if> -->

<div id="edit-interface-wrapper">

<h2>Manage Web Pages</h2>

<div class="message purple"><a class="close_box" href="#">Close</a>
    <strong>Getting Started - Editing your web links</strong><br/>
    <p>Here you can manage the web links that appear on your research hub profile:</p>
    <ul>
        <li>- To reorder existing weblinks, simply drag the weblinks into the desired order, and then click on the "Save Order" button.  To discard any ordering changes you have done since last save, simply click on the Cancel button. </li>
        <li>- To edit an existing weblink, click on the edit icon ( <img src="${urls.images}/individual/editIcon.gif" alt="edit icon" /> ) next to the link you want to edit.
        <li>- To delete an existing weblink, click on the edit icon ( <img src="${urls.images}/individual/deleteIcon.gif" alt="delete icon" /> ) next to the link you want to delete. 
        <li>- To add a new weblink, click on the "Add New Web Page" link at the bottom of this page. </li>
    </ul>
    
</div>
<a class="show_help" href="#">How Do I Use This Page?</a>
       
<script type="text/javascript">
    if(!String.prototype.trim) {  
      String.prototype.trim = function () {  
        return this.replace(/^\s+|\s+$/g,'');  
      };  
    }

    var webpageData = [];
    var collatedReorder = "";
    var collatedRemovals  = [];
    var cancelUrl = "${cancelUrl}&url=/individual";
    var deleteUrl = "${urls.base}/edit/primitiveDelete";
    
    var editImageUrl = "${urls.images}/individual/editIcon.gif";
    var deleteImageUrl = "${urls.images}/individual/deleteIcon.gif";

</script>

<#if !editConfiguration.pageData.webpages?has_content>
    <p>This individual currently has no web pages specified. Add a new web page by clicking on the button below.</p>
</#if>
<h4>Your Current Web Links</h4>
<ul id="webpageList" ${ulClass} role="list">
    <#list editConfiguration.pageData.webpages as webpage>
        <li class="webpage" role="listitem">
            <#if webpage.anchor??>
                <#assign anchor=webpage.anchor >
            <#elseif webpage.url??>
                <#assign anchor=webpage.url >
            <#else>
                <#assign anchor="#" >
            </#if>
            
            <span class="webpageName">
                <a href="${webpage.url}" title="webpage url">${anchor}</a>
            </span>
            <span class="editingLinks">
                <a href="${baseEditWebpageUrl}&objectUri=${webpage.link?url}" class="edit" title="edit web page link"><img class="edit-individual" src="${urls.images}/individual/editIcon.gif" alt="edit" /></a> | 
                <a href="${urls.base}${deleteWebpageUrl}" class="remove" title="delete web page link"><img class="delete-individual" src="${urls.images}/individual/deleteIcon.gif" alt="delete" /></a> 
            </span>
        </li>    
        
        <script type="text/javascript">
            webpageData.push({
                "webpageUri": "${webpage.link}"              
            });
        </script>      
    </#list>  
</ul>


<section id="addAndCancelLinks" role="section">    
    <a href="${showAddFormUrl}" id="showAddForm" title="Add A New Web Page">Add New Web Page</a>
</section>
    <#-- There is no editConfig at this stage, so we don't need to go through postEditCleanup.jsp on cancel.
         These can just be ordinary links, rather than a v:input element, as in 
         addAuthorsToInformationResource.jsp. -->
    <div class="buttonWrapper">
        <section role="section">
            <a href="#" id="saveButton" class="profile button green" title="Save Changes and Return to Profile">Save Changes</a>&nbsp;&nbsp; or <a href="${cancelUrl}" id="cancelButton" title="return to individual">Discard Changes and Return To Profile</a>  
        </section>
    </div>
</div>


<script type="text/javascript">
var customFormData = {
    rankPredicate: '${editConfiguration.pageData.rankPredicate}',
    reorderUrl: '${urls.base}/edit/reorder'
};
</script>

<link rel="stylesheet" href="${urls.base}/edit/forms/css/customForm.css" />
<link rel="stylesheet" href="${urls.base}/edit/forms/css/manageWebpagesForIndividualGU.css" />
<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />

<script type="text/javascript" src="${urls.base}/js/utils.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>
<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>
<script type="text/javascript" src="${urls.base}/edit/forms/js/manageWebpagesForIndividualGU.js"></script>
<!-- GU Common Scripts -->
<script type="text/javascript" src="${urls.base}/edit/forms/js/editInterfaceCommonScripts.js"></script>

<!-- temporary include of cookie script until next build, 060612 -->
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.cookie.js"></script>