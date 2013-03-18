<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for sparkline visualization on individual profile page -->

<#-- Determine whether this person is an author -->
<#assign isAuthor = p.hasStatements(propertyGroups, "${core}authorInAuthorship") />

<#-- Determine whether this person is involved in any grants -->
<#assign isInvestigator = ( p.hasStatements(propertyGroups, "${core}hasInvestigatorRole") ||
                            p.hasStatements(propertyGroups, "${core}hasPrincipalInvestigatorRole") || 
                            p.hasStatements(propertyGroups, "${core}hasCo-PrincipalInvestigatorRole") ) >

<#if (isAuthor || isInvestigator)>
 
    ${stylesheets.add('<link rel="stylesheet" href="${urls.base}/css/visualization/visualization.css" />')}
    
    <section id="visualization" role="region">
        <#if isAuthor>
            <#assign coAuthorIcon = "${urls.images}/visualization/co_author_icon.png">
            <!--<div title="The publication information may be incomplete" class="iconInfo"></div>-->
            <img id="visualisationInformationIcon" style="margin-left:0px;margin-top:0px;" border="0" class="property-sub-title-img" alt="information icon" title="The publication information may be incomplete" src="/themes/gu/images/info_icon.png" />
            
            
            <div id="vis_container_coauthor">&nbsp;
            	<div class="staticPageBackground">
    				<div id="vis_container_coauthor">
    				</div>
    			</div>	
    			
    			<table border="0" width="150">
				<tr>
					<td><span class="dynamicPublicationSparkline"></span></td>
				</tr>
				<tr>
					<td><span id="dynamicPublicationSparklineText"></span></td>
				</tr>
				</tr>
				<tr>
					<td>within the last 10 years</td>
				</tr>
            	</table>
            </div>
            <script type="text/javascript" src="${urls.base}/js/jquery_plugins/jquery.sparkline.min.js"></script>
            <script type="text/javascript">
            var solrServerUrl 	= "${urls.solr}/";
    		var individualTitle = "${title}";
    		var individualUri = "${individual.uri}";
    		
            $(document).ready(function() {
            	var solrQueryUrl = solrServerUrl + 'search?facet=true&' +
				'facet.limit=5&'+
				'facet.mincount=1&'+
				'facet.field={!ex=pub_year}issued&'+
				'f.type.facet.limit=1&'+
				'fq=-PROHIBITED_FROM_TEXT_RESULTS:1=1&'+
				'fq=informationResourceInAuthorship:"'+individualUri+'"=1&'+
				'rows=0&'+
				'json.nl=map&'+
				'f.issued.facet.limit=60000&'+
				'f.issued.facet.sort=index&'+
				'sort=nameLowercaseSingleValued+asc&'+
				'fq={!tag=classgroup}classgroup%3A%22vitroClassGrouppublications%22&'+
				'wt=json&';
				
				solrQueryUrl = solrServerUrl + 'select?facet=true&' +
				'facet.limit=5&' +
				'facet.mincount=1&' +
				'facet.field={!ex=pub_year}dp_issued&' +
				'f.type.facet.limit=1&' +
				'rows=0&' +
				'json.nl=map&' +
				'f.dp_issued.facet.limit=90000&' +
				'f.dp_issued.facet.sort=index&' +
				'fq=op_context_linkedAuthorURI:"'+individualUri+'"&'+
				'fq={!tag=classgroup}classgroup%3A%22vitroClassGrouppublications%22&' +
				'sort=dp_nameLowercaseSingleValued+asc&' +
				'q.alt=*:*&' +
				'wt=json';
				
				var publicationSparklineData = Array();
				var currentYear = (new Date).getFullYear();
				var cutOffYear = currentYear - 10;
				var knownYearPublicationCounts = 0;
				//get solr results for graph   
				$.ajax({
				  url: solrQueryUrl,
				  success: function(data) {   
					//convert the json to a js object
					var tempData = $.parseJSON(data);
					//get just the publication year values from the solr result
					tempData = tempData.facet_counts.facet_fields.dp_issued;
					
					for( i=currentYear; i >= cutOffYear; i--){
						var tempObject = Object();
						tempObject.year = i;
						if (typeof tempData[i] != 'undefined') {
							tempObject.count = tempData[i];
						} else {
							tempObject.count = 0;
						}	
						publicationSparklineData.push(tempObject);
						knownYearPublicationCounts += tempObject.count;
					}
					drawGraph();
				
				  }
				});
            	
            	
            function drawGraph(){	
            
            	var publicationSparklineDataTrimmed = Array();
            	publicationSparklineData.reverse();
                //Get rid of current year
				publicationSparklineData.pop();
				
				/*
				if (publicationSparklineData[(currentYear-1)].count == 0){
					publicationSparklineData.pop();
				}
				*/
				
				var arraySize = publicationSparklineData.length;
				if (arraySize > 10) { 
					//get the last 10 years
					publicationSparklineData = publicationSparklineData.slice(arraySize-10, arraySize)
				}
		
				$.each(publicationSparklineData, function(index, value) {
					publicationSparklineDataTrimmed.push(value.count);
				});
			                                
				$('.dynamicPublicationSparkline').sparkline(publicationSparklineDataTrimmed, {
					type: 'line', 
					width:  '150px',
					height: '60px',
					lineColor: '#3399CC',
					lineWidth: 2,
					fillColor: false
					} 
				);
				if (knownYearPublicationCounts == 1 ) {
					$('#dynamicPublicationSparklineText').html('1 Publication');
				} else {
					$('#dynamicPublicationSparklineText').html(knownYearPublicationCounts + ' Publications');
				}
				
			}//end drawGraph function
				
            });
        </script>
            
           
          
           
        </#if>
       	
    </section>
</#if>
