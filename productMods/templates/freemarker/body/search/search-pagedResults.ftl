<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for displaying paged search results -->
<script type="text/javascript">
    var solrServerUrl 	= "${urls.solr}/";
	var site_url 		= "${urls.base}";
</script>

<#include "search-include-css.ftl">
<#include "search-include-js.ftl">

<div class="clear"></div>

<h2>Search results</h2>
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
			<input type="text" id="query" name="query"/>
			<input type="submit" value="" id="query-btn-submit" src="" class="query-search-btn"> 
		  </div>
      	</div>
	</div>
	
      <div id="search-categories"></div>
      
      <div class="facet collapsed" id="search-facet-1"></div>
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
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/vivoSearchPrototype.config.js"></script>
