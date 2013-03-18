<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for vitro:primaryLink and vitro:additionalLink -->

<#assign linkText="missing link text">

<#if statement.url??>
	<#assign linkText>
		<#if statement.anchor??>
			${statement.anchor}
		<#else>
			${statement.url}
		</#if>    
	</#assign>
     <a target="_blank" href="${statement.url}">${linkText}</a> 
<#elseif statement.core_url??>
	<#assign linkText>
		<#if statement.label??>
			${statement.label}
		<#elseif statement.core_anchor??>
			<#if statement.core_anchor = "uri">
				${statement.core_url}
			<#else>
				${statement.core_anchor}
			</#if>    
			
		<#elseif statement.core_anchor_text??>	
			${statement.core_anchor_text}
		<#else>
			<#if statement.core_url?contains("equella.rcs.griffith.edu.au")>
				View This Collection in the Griffith University Research Data Repository
			<#else>	
				${statement.core_url}
			</#if>
			
		</#if>    
	</#assign>
	
		
	
     <#if inPubLinksSection??>
		<#if statement.core_anchor??>
			<#if statement.core_anchor?contains("Griffith Research Online")>
				<a target="_blank" href="${statement.core_url}">${linkText}</a>  
			</#if>
		</#if>
	<#else>	
			<#if statement.core_url?contains("items-by-author")>
			<#else>	
				<a target="_blank" href="${statement.core_url}">${linkText}</a> 
			</#if>
		
	</#if>

<#else>
     <a target="_blank" href="${profileUrl(statement.link)}">${linkText}</a> (no url provided for link)    
</#if>