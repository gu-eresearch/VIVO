<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for admin panel on individual profile page -->


<#if user.loggedIn>
	<#if individual.person()>

	    <#if individual.profiledPerson()>
	    
	    <#else>    
	        <div id="inactiveProfileInfo">
	            <h2>Welcome to the Griffith Research Hub!</h2>
	            <p class="error"><strong>Your profile is currently inactive.</strong></p>
	            <p>This means it is visible to you but it is not <strong>visible publicly</strong>. Researchers who have a visible profile page have been assessed as "<em>research active</em>". In order for your research activity to be assessed, your publications need to be entered into the <em>MyPubs</em> system (accessed via the <a href="http://www.griffith.edu.au/intranet/" title="Griffith Portal" target="_blank">Griffith Portal</a>) where they undergo a verification process.</p>
	            <p>If you have any questions about your Hub profile, please submit your enquiry using the '<a href="${urls.base!}/contact" title="Contact Us tab">Contact Us</a>' tab.   </p>
	        </div>    
	    </#if>

	</#if>
</#if>

    




