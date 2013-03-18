<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for displaying paged search results -->
<script type="text/javascript">
    var solrServerUrl = "http://vitro-dev.rcs.griffith.edu.au/vivosolr/";
</script>

<link rel="stylesheet" href="${urls.base}/css/search.css" />
<link rel="stylesheet" href="${urls.base}/js/jquery-ui/css/smoothness/jquery-ui-1.8.4.custom.css" />
<link rel="stylesheet" href="${urls.base}/js/jquery_plugins/multiselect/css/ui.multiselect.css" />
<!--<link rel="stylesheet" href="${urls.base}/js/search/prototype_files/vivoSearchPrototype.css" />-->

<script type="text/javascript" src="${urls.base}/js/jquery-ui/js/jquery-ui-1.8.4.custom.min.js"></script>
<script type="text/javascript" src="${urls.base}/js/jquery_plugins/getURLParam.js"></script>

<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/Core.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/AbstractManager.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/managers/Manager.jquery.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/ParameterStore.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/ParameterHashStore.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/AbstractWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/core/AbstractTextWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/ajaxsolr_tjwallace/helpers/jquery/ajaxsolr.theme.js"></script>

<script type="text/javascript" src="${urls.base}/js/search/prototype_files/modifications/Parameter.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/modifications/AbstractFacetWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/modifications/PagerWidget.js"></script>


<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/SearchText.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/TextWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/ClassGroupFacet.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/CurrentSearchWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/MultiCheckboxFacet.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/MultiCheckboxPopup.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/ResultWidget.js"></script>
<script type="text/javascript" src="${urls.base}/js/search/prototype_files/widgets/SortWidget.js"></script>


<script type="text/javascript" src="${urls.base}/js/jquery_plugins/multiselect/js/ui.multiselect.js"></script>







<div id="searchFilterContainer">
	<div class="prop"></div>
	<span id="filterDesc">
		<h4 class="facet-title">Filters:</h4>
	</span>
	<span id="filterWrapper">
		<ul id="selection-breadcrumbs"></ul>
	</span>	
</div>
<div class="clear"></div>
	<#if (page.title == "Projects")>
		<script type="text/javascript">var listingPageFor = "projects";</script>
		<div class="listingDescription">
			<p>Griffith University received close to $100 million in research funding in the last year.<br /> A project is any piece of research work that is undertaken or attempted, with a start and end date and defined objectives </p>
		</div>	
	<#elseif (page.title == "Groups")>
		<script type="text/javascript">var listingPageFor = "groups";</script>
		<div class="listingDescription">
			<p>A group describes an organisational unit at Griffith University that has a relation to a project, publication or researcher in the Research Hub.<br /> Groups represented in the Hub include the four Griffith faculties, Arts. Economics and Law, Science Environment, Engineering and Technology, Health and  Business,  plus schools, centres and research centres. </p>
		</div>	
	<#elseif (page.title == "Researchers")>	
		<script type="text/javascript">var listingPageFor = "researchers";</script>
		<div class="listingDescription">
			<p>At Griffith University there are more than 700 academics actively researching in their field across 37 research centres.<br />  Researchers are linked to publications, projects, other research outputs and Groups.</p>
		</div>
	<#elseif (page.title == "Publications")>	
		<script type="text/javascript">var listingPageFor = "publications";</script>
		<div class="listingDescription">
			<p>There are more than 40000 publications listed in the Research Hub. Publications can be filtered according to their research area, which are governed by the Australian Bureau of Statistics research codes. Publications are divided into the following primary categories:
	Journal Articles, Books, Book Chapters, Conference Papers, Creative Works and Other.</p>
	<p>Griffith is ranked as the number one Australian university for tourism research, and the third internationally for research publications in major journals. There are at present more than 1000 research publications dealing with tourism and in excess of 300 research projects in the Research Hub.  </p>
		</div>
	<#elseif (page.title == "Collections")>	
		<script type="text/javascript">var listingPageFor = "collections";</script>
		<div class="listingDescription">
			<p>A collection is a grouping of physical or data items that have some shared significance. Collections represented in the Hub are research focused and include datasets, collections, repositories or catalogue/indexes. </p>
		</div>
	<#elseif (page.title == "Services")>	
		<script type="text/javascript">var listingPageFor = "services";</script>
		<div class="listingDescription">
			<p>A service supports a research function and the creation and use of research data. Services represented in the Hub include, but are not limited to, syndicate rss or atom, harvest open archives initiative protocol, survey support facilities, research blogs and research intensive conference web sites. </p>
		</div>
	<#else>
		
	</#if>


    <div id="ajax-search" style="display:none;">
      <form id="ajax-search-form" action="/search">
        <input id="ajax-search-text" name="querytext" type="text" value="" />
        <input id="ajax-search-submit" class="button small" name="submit" type="submit" value="Search" />
      </form>
    </div>
<div class="search-wrapper">
    <div id="search-controls">
      <div id="search-categories"></div>
      
      <h3>Free Text Filter</h3>
      <ul id="free-text-filter">
        <input type="text" id="query" name="query"/>
      </ul>

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
	  		<option value="rel">Relevance</option>
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
