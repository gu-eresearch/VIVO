<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->
		</div><!-- #wrapper-content -->

	<footer role="contentinfo">
	<#-- <div id="footer-wrapper"> -->
	
	<div id="footer-wrapper">
	
	<div id="footer-container">
	<div id="iru-logo"></div>
	<#-- <p class="copyright">
	<#if copyright??>
		<small>&copy;${copyright.year?c}
		<#if copyright.url??>
		<a href="${copyright.url}">${copyright.text}</a>
		<#else>
		${copyright.text}
		</#if>
		 | <a class="terms" href="${urls.termsOfUse}">Terms of Use</a></small>
	</#if>
	 Powered by <a class="powered-by-vivo" href="http://vivoweb.org" target="_blank"><strong>VIVO</strong></a>
	<#if user.hasRevisionInfoAccess>
		 | Version <a href="${version.moreInfoUrl}">${version.label}</a> 
	</#if>
	</p> -->
		
		<nav role="navigation">
			<ul id="footer-nav" role="list">
		<#-- <li role="listitem"><a href="${urls.about}">About</a></li> -->
		<#if urls.contact??>
		<#-- <li role="listitem"><a href="${urls.contact}">Contact Us</a></li> -->
				</#if> 
			   <#--  <li role="listitem"><a href="http://www.vivoweb.org/support" target="blank">Support</a></li> -->
			   <li role="listitem"><a href="http://www.griffith.edu.au/cgi-bin/feedbackform.cgi" target="blank">Feedback</a></li>
			<li role="listitem"><a href="http://www.griffith.edu.au/about-griffith/plans-publications/griffith-university-privacy-plan/" target="blank">Privacy policy</a></li>
			<li role="listitem"><a href="http://www.griffith.edu.au/copyright-matters/" target="blank">Copyright matters</a></li>
			<li role="listitem"><a href="http://cricos.deewr.gov.au/Institution/InstitutionDetails.aspx?ProviderID=233" target="blank">CRICOS Provider - 00233E</a></li>
			
			</ul>
		</nav>
	</div>
	</div>
	</footer>
</div> <!-- #wrapper -->
<#include "scripts.ftl">