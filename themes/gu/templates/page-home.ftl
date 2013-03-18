<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->


<@widget name="login" include="assets" />

<!DOCTYPE html>
<html lang="en">
<head>

<#include "head.ftl">


<script type="text/javascript">
	var rss_proxy_url = "${urls.base}/rss_cache.xml";
	var site_url = "${urls.base}";
</script>
<script type="text/javascript" src="${urls.base}/js/gu/home.min.js"></script>

<#--
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/rss_in.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/scrollable.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/scrollable.autoscroll.js"></script>
<script type="text/javascript" src="${urls.base}/js/hp_general.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/jcarousellite_1.0.1.min.js"></script>


-->
<meta name="google-site-verification" content="4sAQA99BVOlIW_GutzzBp6zK9XX6zKI1mdOANnuQ5fw" />
</head>

<body class="${bodyClasses!}">
<#include "identity.ftl">

<#include "menu.ftl">

    <section id="intro" role="region">

	
		<!-- new homepage -->
		<div id="intro-lft-column">
		<div id="intro-lft-content">
			<div id="intro-lft-title" >
				
			</div>
			<div id="intro-lft-rss">
			
			<div class="rss-wrapper"><ul class="ul-rss-wrapper"></ul></div> 
			
			</div>
			<div id="intro-lft-search">
				<div class="searchHeader">Find a</div>
				<ul id="intro-lft-search-nav">
        <li class="active">Researcher</li>
        <li>Keyword</li>
    </ul>
    <div id="intro-left-search-container">
    	<div id="intro-left-rsearch">
            <form action="javascript:submit_researcher_form();">
                <ul class="intro-left-search-body">
                    <li><label class="intro-left-search-name">Name</label></li>
                    <li>
                        <input id="intro-left-rsearch-input" class="intro-left-search-input" type="text" value="" />
                        <button id="intro-left-rsearch-btn" class="intro-left-search-btn" type="submit">search</button> 
                    </li>
                </ul>
            </form>
        </div>
        <div id="intro-left-tsearch"  style="display:none;">
            <form action="javascript:submit_keyword_form();">
                <ul class="intro-left-search-body">
                    <li><label class="intro-left-search-name">Keyword</label></li>
                    <li>
                        <input id="intro-left-tsearch-input" class="intro-left-search-input" title="Search Keywords" type="text" value="" />
                        <button id="intro-left-tsearch-btn" class="intro-left-search-btn" type="submit">search</button> 
                    </li>
                </ul>
            </form>
        </div>
    </div>
			</div>
			
		</div>
		</div>
		<div id="intro-rght-column">
			<div class="into-right-text"><span>Welcome to Griffith University's Research Hub, a rich and informative guide to the University's expertise in a comprehensive array of academic fields.</span></div>
			<div id="into-right-btns">
			<ul>
			
			<li id="hero_btn2"><a href="${urls.base}/researchers"><span class="hero_btn_txt_box"><span>Research Expertise</span></span></a></li>
			<li id="hero_btn3"><a href="${urls.base}/groups"><span class="hero_btn_txt_box"><span>Research Groups</span></span></a></li>		
			<li id="hero_btn4"><a href="${urls.base}/projects"><span class="hero_btn_txt_box"><span>Current Projects</span></span></a></li>
			
			<li id="hero_btn5"><a href="http://www.griffith.edu.au/higher-degrees-research" target="_blank"><span class="hero_btn_txt_box"><span>Research Degrees</span></span></a></li>
			<li id="hero_btn1"><a href="${urls.base}/researchers"><span class="hero_btn_txt_box"><span>Find a Supervisor</span></span></a></li>
			<li id="hero_btn6"><a href="http://www.griffith.edu.au/higher-degrees-research/how-to-apply" target="_blank"><span class="hero_btn_txt_box"><span>Apply Now</span></span></span></a></li>
	
	
	
			
			</ul>
			</div>
			<div class="into-right-text smlr"><span>Griffith University is a Top 10 Australian research university. Analysis of the Excellence in Research for Australia 2010 National Report places Griffith among Australia's most highly regarded universities, with close to 93 per cent of staff aligned with fields of research rated world standard or above.</span></div>
		</div>

    </section> <!-- #intro -->

        <#include "footer.ftl">
    </body>
 
 
</html>


                  
