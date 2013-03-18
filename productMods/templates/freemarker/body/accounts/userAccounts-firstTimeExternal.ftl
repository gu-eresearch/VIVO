<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for creating an account for the first time an external user logs in. -->
<link rel="stylesheet" href="/js/jquery-ui/css/smoothness/jquery-ui-1.8.9.custom.css" />
<link rel="stylesheet" href="/edit/forms/css/customForm.css" />
<link rel="stylesheet" href="/edit/forms/css/customFormWithAutocomplete.css" />
<div id="form-wrapper">
    <h2>First time log in</h2>

        <#if errorEmailIsEmpty??>
            <#assign errorMessage = "You must supply an email address." />
        </#if>
        
        <#if errorEmailInUse??>
            <#assign errorMessage = "An account with that email address already exists." />
        </#if>
        
        <#if errorEmailInvalidFormat??>
            <#assign errorMessage = "'${emailAddress}' is not a valid email address." />
        </#if>
        
        <#if errorFirstNameIsEmpty??>
            <#assign errorMessage = "You must supply a first name." />
        </#if>
        
        <#if errorLastNameIsEmpty??>
            <#assign errorMessage = "You must supply a last name." />
        </#if>
        
        <#if errorMessage?has_content>
            <section id="error-alert" role="alert">
                <img src="${urls.images}/iconAlert.png" width="24" height="24" alert="Error alert icon"/>
                <p>${errorMessage}</p>
            </section>
        </#if>

    <section id="first-time-login" role="region">
        <p>Please provide your contact information to finish creating your account.</p>

        <form method="POST" action="${formUrls.firstTimeExternal}" class="customForm" role="my account">
            <input type="hidden" name="externalAuthId" value="${externalAuthId}" role="input" />
            <input type="hidden" name="afterLoginUrl" value="${afterLoginUrl}" role="input" />
        
            <p>
                <label for="first-name">First name<span class="requiredHint"> *</span></label> 
                <input type="text" name="firstName" value="${firstName}" id="first-name" role="input" />
            </p>
            <p>
                <label for="last-name">Last name<span class="requiredHint"> *</span></label> 
                <input type="text" name="lastName" value="${lastName}" id="last-name" role="input" />
            </p>
            <p>
                <label for="email-address">Email address<span class="requiredHint"> *</span></label>
                <input type="text" name="emailAddress" value="${emailAddress}" id="email-address" role="input" />
            </p>

            <#if emailIsEnabled??>
                <p class="note" style="margin:15px 0px;">
                    Note: An email will be sent to the address entered above notifying 
                    that an account has been created.
                </p>
            </#if>

            <p><input type="submit" name="submit" value="Create account" class="submit"/> or <a class="cancel" href="${urls.home}" title="cancel">Cancel</a></p>
        </form>
    </section>
</div>
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/account/account.css" />')}
${stylesheets.add('<link rel="stylesheet" href="${urls.base}/edit/forms/css/customForm.css" />')}