<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Contact form processing errors -->

<h2>${title}</h2>

    <#if errorMessage?has_content>       

        <div id="error-alert"><img src="${urls.images}/iconAlert.png"/>
                  <p>${errorMessage}</p>
           </div>
       
    </#if>

<p>Use the browser's back button to return to the form on the previous page.</p>
