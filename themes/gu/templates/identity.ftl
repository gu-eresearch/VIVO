<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<header id="branding" role="banner">
<div id="head-navbar"></div>
<#-- <div id="head-content"></div> -->
<div id="header-container">
    <a title="Griffith University" href="http://www.griffith.edu.au/"><h1 class="gu-logo"><span class="displace">${siteName}</span></h1></a>
    <h1 class="vivo-logo"><a title="Griffith University Research Hub" href="${urls.home}"><span class="research">Research </span><span class="hub">Hub</span></a></h1>
    <#-- Since we are using a graphic text for the tagline, we won't render ${siteTagline}
    <#if siteTagline?has_content>
        <em>${siteTagline}</em>
    </#if>-->
<div id="toolbar">
<ul>
    <li>Change text size: |</li>
    <li><a onclick="setActiveStyleSheetText(-1); return false;" href="#"><abbr title="decrease text size">A-</abbr></a> | </li>

    <li><a onclick="setActiveStyleSheetText(1); return false;" href="#"><abbr title="increase text size">A+</abbr></a></li>
</ul>
</div>
    <nav role="navigation">
    
        <ul id="header-nav" role="list">
           <#-- <#if user.loggedIn>
                <li role="listitem"><img class="middle" src="${urls.images}/userIcon.png" alt="user icon" />${user.loginName}</li>
                <li role="listitem"><a href="${urls.logout}">Log out</a></li>
                <#if user.hasSiteAdminAccess>
                    <li role="listitem"><a href="${urls.siteAdmin}">Site Admin</a></li>
                </#if>
            <#else>
                <li role="listitem"><a title="log in to manage this site" href="${urls.login}">Log in</a></li>
            </#if> -->
            <#-- List of links that appear in submenus, like the header and footer. -->
               <#-- <li role="listitem"><a href="${urls.about}">About</a></li> -->
            <#if urls.contact??>
               <#-- <li role="listitem"><a href="${urls.contact}">Contact Us</a></li> -->
            </#if>
          <#--      <li role="listitem"><a href="http://www.vivoweb.org/support" target="blank">Support</a></li>
                <li role="listitem"><a href="${urls.index}">Index</a></li> -->
        <li role="listitem"><a href="http://www.griffith.edu.au/intranet/">Griffith Portal</a></li>
        <li role="listitem"><a href="http://www.griffith.edu.au/search/">Phonebook</a></li>

        </ul>
    </nav>
    
    <section id="search" role="region">
        <fieldset>
            <legend>Search form</legend>
            <div id="ajax-search" >
            <div id="search-field">
              <form id="ajax-search-form" action="${urls.base}/search">
                <input id="ajax-search-text" title="Search" name="querytext" type="text" class="search-vivo" value="${querytext!}" />
                <input id="ajax-search-submit" class="search" name="submit" type="submit" value="Search" />
              </form>
              </div>
            </div>
            <!--
            <form id="search-form" action="${urls.search}" method="POST" name="search" role="search"> 
               
                
                <div id="search-field">
                    <input type="text" name="querytext" class="search-vivo" value="${querytext!}" />
                    <input type="submit" name="submit" value="Search" class="search">
                </div>
            </form>
            
            -->
        </fieldset>
    </section>
</div>
</header>
