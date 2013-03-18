<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for displaying paged search results -->
<script type="text/javascript">
   	var solrServerUrl 	= "${urls.solr}/";
	var site_url 		= "${urls.base}";
</script>

<#include "*/search/search-include-css.ftl">
<#include "*/search/search-include-js.ftl">



<!--<div id="searchFilterContainer">
	<div class="prop"></div>
	<span id="filterDesc">
		<h4 class="facet-title">Keywords:</h4>
	</span>
	<span id="filterWrapper">
		<ul id="selection-breadcrumbs"></ul>
	</span>	
</div>-->
<div class="clear"></div>
	<#if (page.title == "Projects")>
		<script type="text/javascript">var listingPageFor = "projects";</script>
		<div class="listingDescription">
			<p>Griffith University received close to $100 million in research funding in the last year.<br /> A project is any piece of research work that is undertaken or attempted, with a start and end date and defined objectives </p>
		</div>	
	<#elseif (page.title == "Groups")>
		<script type="text/javascript">var listingPageFor = "groups";</script>
		<div class="listingDescription">
			<p>At Griffith University researchers are grouped in Academic Groups: Arts, Education and Law; Science, Environment and Technology; Health; and Business, schools and/or research centres.</p>
		</div>	
	<#elseif (page.title == "Researchers")>	
		<script type="text/javascript">var listingPageFor = "researchers";</script>
		<div class="listingDescription">
			<p>At Griffith University there are more than 800 academics actively researching in their field across a number of research centres.<br />  Researchers are linked to publications, projects, other research outputs and groups.</p>
		</div>
	<#elseif (page.title == "Publications")>	
		<script type="text/javascript">var listingPageFor = "publications";</script>
		<div class="listingDescription">
			<p>There are more than 40000 publications listed in the Research Hub. Publications can be filtered according to their research area, which are governed by the Australian Bureau of Statistics research codes. Publications are divided into the following primary categories:
	Journal Articles, Books, Book Chapters, Conference Papers, Creative Works and Other.</p>
	
		</div>
	<#elseif (page.title == "Collections")>	
		<script type="text/javascript">var listingPageFor = "collections";</script>
		<div class="listingDescription">
			<p>A collection is a grouping of physical or data items that have some shared significance. Collections represented in the Hub are research focused and include datasets, collections, repositories or catalogue/indexes. </p>
		</div>
	<#elseif (page.title == "Services")>	
		<script type="text/javascript">var listingPageFor = "services";</script>
		<div class="listingDescription">
			<p>Services include both systems intended for use directly by researchers or the machines and software that they use in their research. It is an Australian Federal Government priority to make strategic investments in shared infrastructure and services to both increase the capacity of Australian Research and to increase the quality and impact of Australian research. The number and variety of these services at Griffith is growing all the time, and beyond their immediate utility to individual researchers, they also act as valuable attractors or gateways to Griffith research output within specific research domains.</p>
		</p>
		</div>
	<#else>
		
	</#if>


    <div id="ajax-search" style="display:none;">
      <form id="ajax-search-form" action="${urls.base}/search">
        <input id="ajax-search-text" name="querytext" type="text" value="" />
        <input id="ajax-search-submit" class="button small" name="submit" type="submit" value="Search" />
      </form>
    </div>
<div class="search-wrapper">
    <div id="search-controls">
	
	<div id="searchFilterContainer">
		<div id="facet-container">
			
			<div id="filterDesc">
				<h3 class="facet-title">Narrow your search results</h3>
			</div>
			<div id="filterWrapper">
				<ul id="selection-breadcrumbs">
					<li id="facet-heading">Keywords</li>
				</ul>
			</div>
			
		</div>
		<div class="facet">
		  <h4 class="facet-title">Keyword(s)</h4>
		  <div id="free-text-filter">
			<input type="text" id="query" title="Refine Search by Keyword" name="query"/>
			<input type="submit" value="" id="query-btn-submit" src="" 
class="query-search-btn"> 
		  </div>
      	</div>
	</div>
	
      <div id="search-categories"></div>
      

      <div class="facet" id="search-facet-1"></div>
      <div class="facet facet-popup" id="search-facet-1-popup" style="display: none;"></div>

      <div class="facet" id="search-facet-2"></div>
      <div class="facet facet-popup" id="search-facet-2-popup" style="display: none;"></div>

      <div class="facet" id="search-facet-3"></div>
      <div class="facet facet-popup" id="search-facet-3-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-5"></div>
      <div class="facet facet-popup" id="search-facet-5-popup" style="display: none;"></div>

      <div class="facet" id="search-facet-4"></div>

      <div class="facet facet-popup" id="search-facet-4-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-6"></div>
      <div class="facet facet-popup" id="search-facet-6-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-7"></div>
      <div class="facet facet-popup" id="search-facet-7-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-8"></div>
      <div class="facet facet-popup" id="search-facet-8-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-9"></div>
      <div class="facet facet-popup" id="search-facet-9-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-10"></div>
      <div class="facet facet-popup" id="search-facet-10-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-11"></div>
      <div class="facet facet-popup" id="search-facet-11-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-12"></div>
      <div class="facet facet-popup" id="search-facet-12-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-13"></div>
      <div class="facet facet-popup" id="search-facet-13-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-14"></div>
      <div class="facet facet-popup" id="search-facet-14-popup" style="display: none;"></div>
      
      <div class="facet" id="search-facet-15"></div>
      <div class="facet facet-popup" id="search-facet-15-popup" style="display: none;"></div>
    </div>

<div id="search-results">
	<div id="sort-widget">
	    <!--<span>Sorting by:</span>-->
	  	<select id="sort-select" name="sort-select">
	  		<option value="rel">Best Match</option>
	  		<option value="date_new">Date (Newest first)</option>
	  		<option value="date_old">Date (Oldest first)</option>
	  		<option value="alpha_asc">Alphabetical (ascending)</option>
	  		<option value="alpha_desc">Alphabetical (descending)</option>
	  	</select>
	  </div>
  <div id="results-header"></div>
  <div id="results"></div>
  <div id="pagination">
    <ul id="pager"></ul>
  </div>
</div>
</div>


<div style="clear:both"></div>

<script type="text/javascript" src="${urls.base}/js/search/prototype_files/vivoSearchPrototype.theme.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/vivoSearchListing.config.js"></script>
