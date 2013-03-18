<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->
<div id="wrapper">
	<div id="wrapper-content" role="main"> 
		<nav role="navigation" id="login-menu">
			<ul id="login-nav" role="list">
				<#if user.loggedIn>
					<#--<li role="listitem"><img class="middle" src="${urls.images}/userIcon.png" alt="user icon" />${user.loginName}</li>-->
					<li role="listitem"><b>Logged in:</b> ${user.loginName}</li>
					<li role="listitem"><a href="${urls.logout}">Log out</a></li>
					<#if user.hasSiteAdminAccess>
						<li role="listitem"><a href="${urls.siteAdmin}">Site Admin</a></li>
					</#if>
				<#else>
					<li role="listitem"><a title="log in to manage this site" href="${urls.login}">Log in</a></li>
				</#if>
			</ul>
		</nav>
		<nav role="navigation">
			<ul id="main-nav" role="navigation" itemscope="itemscope" itemtype="http://schema.org/SiteNavigationElement">
				<#list menu.items as item>
					<li role="listitem"><#if item.active> <span class="selected-main-nav"></span> </#if><a href="${item.url}" <#if item.active> class="selected" </#if> data-link="${item.linkText}">${item.linkText}</a><span class="separator-main-nav"></span></li>
				</#list>
				<!--
				<li role="listitem"><#if title == "About Research Hub"> <span class="selected-main-nav"></span> </#if><a href="${urls.base}/about" <#if title == "About Research Hub"> class="selected" </#if> data-link="About">About</a><span class="separator-main-nav"></span></li>
				<li role="listitem"><#if title == "Research Hub Help"> <span class="selected-main-nav"></span> </#if><a id="helpMenuLink" href="${urls.base}/help" <#if title == "Research Hub Help"> class="selected" </#if> data-link="Help">Help</a><span class="separator-main-nav"></span></li>
				-->
				<li role="listitem"><#if title == "Research Hub Feedback Form"> <span class="selected-main-nav"></span> </#if><a href="${urls.base}/contact" <#if title == "Research Hub Feedback Form"> class="selected" </#if> data-link="Contact">Contact Us</a><span class="separator-main-nav"></span></li>
				
			</ul>
		</nav>
			
				<#if flash?has_content>
					<#if flash?starts_with("Welcome") >
						<section  id="welcome-msg-container" role="container">
							<section  id="welcome-message" role="alert">${flash}</section>
						</section>
					<#else>
						<section id="flash-message" role="alert">
							${flash}
						</section>
					</#if>
				</#if>
				
				<!--[if lte IE 8]>
				<noscript>
					<p class="ie-alert">This site uses HTML elements that are not recognized by Internet Explorer 8 and below in the absence of JavaScript. As a result, the site will not be rendered appropriately. To correct this, please either enable JavaScript, upgrade to Internet Explorer 9, or use another browser.</p>
				</noscript>
				<![endif]-->
