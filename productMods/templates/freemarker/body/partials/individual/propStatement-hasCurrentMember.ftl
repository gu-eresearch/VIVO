<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Default object property statement template -->
<#if statement.hasProfile?number = 1>
	<a href="${profileUrl(statement.object)}">${statement.name!}</a> 
	<#if statement.title??>
	| ${statement.title!}
	</#if>

<#else>
	${statement.name!}</a> 
</#if>