<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->
<#import "lib-vivo-form.ftl" as lvf>

<#--Retrieve certain edit configuration information-->
<#assign editMode = editConfiguration.pageData.editMode />
<#assign literalValues = editConfiguration.existingLiteralValues />
<#assign uriValues = editConfiguration.existingUriValues />
<#assign htmlForElements = editConfiguration.pageData.htmlForElements />
<#assign showRoleLabelField = editConfiguration.pageData.showRoleLabelField />

<#assign allExistingRoleLabels = editConfiguration.pageData.allExistingRoleLabels!/>
<#assign allExistingOrgLabels = editConfiguration.pageData.allExistingOrgLabels!/>

<#--If edit submission exists, then retrieve validation errors if they exist-->
<#if editSubmission?has_content && editSubmission.submissionExists = true && editSubmission.validationErrors?has_content>
    <#assign submissionErrors = editSubmission.validationErrors/>
</#if>
<#--Freemarker variables with default values that can be overridden by specific forms-->

<#assign blankSentinel = "" />
<#if editConfigurationConstants?has_content && editConfigurationConstants?keys?seq_contains("BLANK_SENTINEL")>
    <#assign blankSentinel = editConfigurationConstants["BLANK_SENTINEL"] />
</#if>

<#--This flag is for clearing the label field on submission for an existing object being selected from autocomplete.
Set this flag on the input acUriReceiver where you would like this behavior to occur. -->
<#assign flagClearLabelForExisting = "flagClearLabelForExisting" />


<#-- typeSelectorLabel, numDateFields,  roleExamples, roleActivityVClass -->

<#if !typeSelectorLabel?has_content>
    <#assign typeSelectorLabel = roleDescriptor />
</#if>
<#if !numDateFields?has_content>
    <#assign numDateFields = 2 />
</#if>

<#if !roleExamples?has_content>
    <#assign roleExamples = "" />
</#if>

<#if !roleActivityVClass?has_content>
    <#assign roleActivityVClass = "" />
</#if>

<#--Setting values for titleVerb, submitButonText, and disabled Value-->
<#if editConfiguration.objectUri?has_content>
    <#assign titleVerb = "Edit"/>
    <#assign submitButtonText>Save Changes</#assign>
    <#if editMode = "repair">
        <#assign disabledVal = ""/>
    <#else>
        <#assign disabledVal = "disabled"/>
    </#if>
<#else>
    <#assign titleVerb = "Create"/>
    <#assign submitButtonText>Create Entry</#assign>
    <#assign disabledVal = ""/>
    <#assign editMode = "add" />
</#if>

<#--Get existing value for specific data literals and uris-->


<#--Get selected activity type value if it exists, this is alternative to below-->
<#assign activityTypeValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "roleActivityType")/>

 <#--Get activity label value-->
<#assign activityLabelValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "activityLabel") />
<#assign activityLabelDisplayValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "activityLabelDisplay") />


<#--Get role label-->
<#assign roleLabel = lvf.getFormFieldValue(editSubmission, editConfiguration, "roleLabel") />

<#--Get role desc-->
<#assign roleDesc = lvf.getFormFieldValue(editSubmission, editConfiguration, "roleDesc") />

<#--For role activity uri-->
<#assign existingRoleActivityValue = lvf.getFormFieldValue(editSubmission, editConfiguration, "existingRoleActivity") />


<#assign requiredHint = "<span class='requiredHint'> *</span>" />
<#assign yearHint     = "<span class='hint'>(YYYY)</span>" />


<script type="text/javascript">
    var existingRoleLabelData = [];
    <#if allExistingRoleLabels??>
        <#list allExistingRoleLabels as lab>
            existingRoleLabelData.push({
                "label": "${lab.label!}"
            });        
        </#list> 
    </#if>
    
    var existingOrgLabelData = [];
    <#if allExistingOrgLabels??>
        <#list allExistingOrgLabels as lab>
            existingOrgLabelData.push({
                "label": "${lab.label!}"
            });        
        </#list> 
    </#if>
</script>

<div id="form-wrapper">

<h2>${titleVerb}&nbsp;${roleDescriptor} entry for ${editConfiguration.subjectName}</h2>

<#--Display error messages if any-->
<#if activityLabelDisplayValue?has_content >
    <#assign activityLabelValue = activityLabelDisplayValue />
</#if>


<#if submissionErrors?has_content>
    <section id="error-alert" role="alert">
        <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="Error alert icon" />
        <p>
        <#--below shows examples of both printing out all error messages and checking the error message for a specific field-->
        <#list submissionErrors?keys as errorFieldName>
            <#if errorFieldName == "startField">
                <#if submissionErrors[errorFieldName]?contains("before")>
                    The Start Year must be earlier than the End Year.
                <#else>
                    ${submissionErrors[errorFieldName]}
                </#if>
                <br />
            <#elseif errorFieldName == "endField">
                <#if submissionErrors[errorFieldName]?contains("after")>
                    The End Year must be later than the Start Year.
                <#else>
                    ${submissionErrors[errorFieldName]}
                </#if>
            </#if>
        </#list>
        <#--Checking if Name field is empty-->
         <#if lvf.submissionErrorExists(editSubmission, "activityLabel")>
            Please enter or select a value in the Name field.<br />
        </#if>
        <#--Checking if role field is empty-->
        <#if lvf.submissionErrorExists(editSubmission, "roleLabel")>
            Please specify a role for this activity.
        </#if>
        
        </p>
    </section>
</#if>

<@lvf.unsupportedBrowser urls.base /> 

<section id="add${roleDescriptor?capitalize}RoleToPersonTwoStage" role="region">        
    
    <form id="add${roleDescriptor?capitalize}RoleToPersonTwoStage" class="customForm noIE67" action="${submitUrl}"  role="add/edit grant role">

       <p class="inline">
        <label for="typeSelector">${typeSelectorLabel?capitalize}<#if editMode != "edit"> ${requiredHint}<#else>:</#if></label>
        <#--Code below allows for selection of first 'select one' option if no activity type selected-->
        <#if activityTypeValue?has_content>
            <#assign selectedActivityType = activityTypeValue />
        <#else>
            <#assign selectedActivityType = "" />
        </#if>
            <#assign roleActivityTypeSelect = editConfiguration.pageData.roleActivityType />
            <#assign roleActivityTypeKeys = roleActivityTypeSelect?keys />

        <#if editMode != "edit" || ( editMode == "edit" && roleActivityVClass == "organizations") >
            <select id="typeSelector" name="roleActivityType" acGroupName="activity">
                <#list roleActivityTypeKeys as key>
                    <option value="${key}"<#if selectedActivityType = key>selected</#if>>${roleActivityTypeSelect[key]}</option>
                </#list>
            </select>
        <#else>
           <#list roleActivityTypeKeys as key>             
               <#if selectedActivityType = key >
                 <span class="readOnly" id="typeSelectorSpan">${roleActivityTypeSelect[key]}</span> 
                 <input type="hidden" id="typeSelectorInput" name="roleActivityType" acGroupName="activity" value="${activityTypeValue}" >
               </#if>           
           </#list>
        </#if>
       </p>
       
       
            <p>
                <label for="activity">Organisation Name ${requiredHint}</label>
                <input class="acSelector1212" size="50"  type="text" id="activity" name="activityLabel"  acGroupName="activity" value="${activityLabelValue}" />
                <input class="display" type="hidden" id="activityDisplay" acGroupName="activity" name="activityLabelDisplay" value="${activityLabelDisplayValue}">
            </p>
            
            <input type="hidden" id="roleToActivityPredicate" name="roleToActivityPredicate" value="" />
            <!--Populated or modified by JavaScript based on type of activity, type returned from AJAX request-->

            <div class="acSelection" acGroupName="activity">
                <p class="inline">
                    <label></label>
                    <span class="acSelectionInfo"></span>
                    <a href="/vivo/individual?uri=" class="verifyMatch" title="verify match">(Verify this match</a> or 
                    <a href="#" class="changeSelection" id="changeSelection">change selection)</a>

                    </p>
                    <input class="acUriReceiver" type="hidden" id="roleActivityUri" name="existingRoleActivity"  value="${existingRoleActivityValue}" ${flagClearLabelForExisting}="true" />
                    <!-- Field value populated by JavaScript -->
            </div>


            <p><label for="roleLabel">Role Name ${requiredHint} ${roleExamples}</label>
                <input  size="50"  type="text" id="roleLabel" name="roleLabel" value="${roleLabel!}" />
            </p>
            <p><label for="roleDesc">Role Description</label>
                <input  size="50"  type="text" id="roleDesc" name="roleDesc" value="${roleDesc!}" />
            </p>

            
            <#if numDateFields == 1 >
               <#--Generated html is a map with key name mapping to html string-->
               <#if htmlForElements?keys?seq_contains("startField")>
                    Start  ${htmlForElements["startField"]} ${yearHint}
               </#if>
            <#else>
                <h4 class="label">Years of Participation in Role </h4>
                <#if htmlForElements?keys?seq_contains("startField")>
                        Start ${htmlForElements["startField"]} ${yearHint}
               </#if>
               <#if htmlForElements?keys?seq_contains("endField")>
                       <br/>End ${htmlForElements["endField"]} ${yearHint}
               </#if>
            </#if>


        <p class="submit">
            <input type="hidden" id="editKey" name="editKey" value="${editKey}" />
            <input type="submit" id="submit" value="${submitButtonText}"/><span class="or"> or </span><a class="cancel" href="${cancelUrl}" title="Cancel">Cancel</a>
        </p>

        <p id="requiredLegend" class="requiredHint">* required fields</p>
    </form>

<#--Specifying form-specific script and adding stylesheets and scripts-->    
    
 <script type="text/javascript">
    
        var customFormData  = {
            acUrl: '${urls.base}/autocomplete?tokenize=true',
            editMode: '${editMode}',
            defaultTypeName: 'activity', // used in repair mode, to generate button text and org name field label
            baseHref: '${urls.base}/individual?uri=',
            blankSentinel: '${blankSentinel}',
            flagClearLabelForExisting: '${flagClearLabelForExisting}'
        };
        $(document).ready(function() {
            $("#activity").autocomplete({
                minLength: 1,
                source: existingOrgLabelData,
                focus: function( event, ui ) {
                    $( "#activity" ).val( ui.item.label );
                    return false;
                },      
                select: function( event, ui ) {
                    $( "#activity" ).val( ui.item.label );
                    return false;
                }
            });
            
            $( "#roleLabel" ).autocomplete({
                minLength: 1,
                source: existingRoleLabelData,
                focus: function( event, ui ) {
                    $( "#roleLabel" ).val( ui.item.label );
                    return false;
                },      
                select: function( event, ui ) {
                    $( "#roleLabel" ).val( ui.item.label );
                    return false;
                }
            });
        });
    </script>

${stylesheets.add('<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customForm.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/templates/freemarker/edit/forms/css/customFormWithAutocomplete.css" />')}

${scripts.add('<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.9.custom.min.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/browserUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/js/customFormUtils.js"></script>')}
${scripts.add('<script type="text/javascript" src="${urls.base}/templates/freemarker/edit/forms/js/customFormWithAutocomplete.js"></script>')}

</section>   
</div>