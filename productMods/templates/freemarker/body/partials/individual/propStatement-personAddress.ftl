<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Custom object property statement view for http://vivoweb.org/ontology/core#mailingAddress -->

<#import "lib-sequence.ftl" as s>
<#import "lib-datetime.ftl" as dt>

<@showAddress statement />

<#-- Use a macro to keep variable assignments local; otherwise the values carry over to the
     next statement -->
<#macro showAddress statement>


<span id="guAddressContainer">
	<#if statement.location??>
		<div>${statement.location}</div>
	</#if>
	<#if statement.campus??>
		<div>${statement.campus}</div>
	</#if>
	<#if statement.postalAddress??>
		<div>${statement.postalAddress}</div>
	</#if>
   
  
</span>
    

</#macro>
