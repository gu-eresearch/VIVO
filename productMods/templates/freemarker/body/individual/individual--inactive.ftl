<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for gu:RADPerson individuals -->

<#include "individual-setup.ftl">
<script type="text/javascript">
	var site_url 		= "${urls.base}"; 
</script>

<#include "individual-include-css.ftl">
<#include "individual-include-js.ftl">



<div id="breadcrumbs">
	<ul>
	<li><a href="${urls.base}/">Research Hub</a>&nbsp;&nbsp;&raquo;</li>
	<li><a href="${urls.base}/researchers">Researchers</a>&nbsp;&nbsp;&raquo;</li>
	<li>
	<#if (title?length > 140)>
		<span>${title?substring(0, 139)}</span><span> ...</span>
		
	<#else>
		${title}
	</#if>

	</li>
	</ul>
</div>

<div>
	<p>This profile is currently inactive. </p>
	<p>If you think this is incorrect, please contact system administrators.</p>
	<p>Thank you.</p>
</div>     




