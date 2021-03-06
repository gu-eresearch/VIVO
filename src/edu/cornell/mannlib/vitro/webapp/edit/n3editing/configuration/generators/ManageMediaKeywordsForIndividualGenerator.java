/*
Copyright (c) 2012, Cornell University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of Cornell University nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
*/
package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpSession;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.freemarker.UrlBuilder;
import edu.cornell.mannlib.vitro.webapp.controller.freemarker.UrlBuilder.ParamMap;
import edu.cornell.mannlib.vitro.webapp.dao.jena.QueryUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationUtils;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;

/**
 * This is an odd controller that is just drawing a page with links on it.
 * It is not an example of the normal use of the RDF editing system and
 * was just migrated over from an odd use of the JSP RDF editing system
 * during the 1.4 release. 
 * 
 * This mainly sets up pageData for the template to use.
 */
public class ManageMediaKeywordsForIndividualGenerator extends BaseEditConfigurationGenerator implements EditConfigurationGenerator {
    public static Log log = LogFactory.getLog(ManageMediaKeywordsForIndividualGenerator.class);
    
    @Override
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) {

        EditConfigurationVTwo config = new EditConfigurationVTwo();
        config.setTemplate("manageMediaKeywordsForIndividual.ftl");

        initBasics(config, vreq);
        initPropertyParameters(vreq, session, config);
        initObjectPropForm(config, vreq);

        config.setSubjectUri(EditConfigurationUtils.getSubjectUri(vreq));
        config.setEntityToReturnTo( EditConfigurationUtils.getSubjectUri(vreq));

        List<Map<String,String>> mediaKeywords = getMediaKeywords(config.getSubjectUri(), vreq);
        config.addFormSpecificData("mediaKeywords",mediaKeywords);
        
        List<Map<String,String>> allMediaKeywords = getAllMediaKeywords(vreq);
        config.addFormSpecificData("allMediaKeywords",allMediaKeywords);

        config.addFormSpecificData("rankPredicate", "http://vivoweb.org/ontology/core#rank" );
        config.addFormSpecificData("reorderUrl", "/edit/reorder" );       
        config.addFormSpecificData("deleteMediaKeywordUrl", "/edit/primitiveDelete");              

        ParamMap paramMap = new ParamMap();
        paramMap.put("subjectUri", config.getSubjectUri());
        paramMap.put("editForm", AddEditMediaKeywordFormGenerator.class.getName());
        paramMap.put("view", "form");
        String path = UrlBuilder.getUrl( UrlBuilder.Route.EDIT_REQUEST_DISPATCH ,paramMap);

        config.addFormSpecificData("baseEditMediaKeywordUrl", path);                 

        paramMap = new ParamMap();
        paramMap.put("subjectUri", config.getSubjectUri());
        paramMap.put("predicateUri", config.getPredicateUri());
        paramMap.put("editForm" , AddEditMediaKeywordFormGenerator.class.getName() );
        paramMap.put("cancelTo", "manage");
        path = UrlBuilder.getUrl( UrlBuilder.Route.EDIT_REQUEST_DISPATCH ,paramMap);

        config.addFormSpecificData("showAddFormUrl", path);          

        Individual subject = vreq.getWebappDaoFactory().getIndividualDao().getIndividualByURI(config.getSubjectUri());
        if( subject != null && subject.getName() != null ){
            config.addFormSpecificData("subjectName", subject.getName());
        }else{
            config.addFormSpecificData("subjectName", null);
        }
        prepare(vreq, config);
        return config;
    }
  

        
    private static String RESEARCH_AREA_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "PREFIX guhubext:  <http://griffith.edu.au/ontology/hubextensions/> \n"
        + "SELECT DISTINCT ?mediaKeyword (str(?Label) as ?label) (str(?Rank) as ?rank) WHERE { \n"
        + "    ?subject guhubext:hasMediaKeyword ?mediaKeyword . \n"
        + "    OPTIONAL { ?mediaKeyword rdfs:label ?Label } \n"
        + "    OPTIONAL { ?mediaKeyword core:rank ?Rank } \n"
        + "} ORDER BY ?rank";  
        
    private static String ALL_RESEARCH_KEWORDS_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "PREFIX guhubext:  <http://griffith.edu.au/ontology/hubextensions/> \n"
        + "SELECT DISTINCT ?mediaKeyword (str(?Label) as ?label)  WHERE { \n"
        + "    ?subject guhubext:hasMediaKeyword ?mediaKeyword . \n"
        + "    ?mediaKeyword rdfs:label ?Label  \n"
        + "} ";      
    
    
    private List<Map<String, String>> getMediaKeywords(String subjectUri, VitroRequest vreq) {
          
        String queryStr = QueryUtils.subUriForQueryVar(RESEARCH_AREA_QUERY, "subject", subjectUri);
        log.debug("Research Keywords Query string is: " + queryStr);
        List<Map<String, String>> mediaKeywords = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("label");
                if (node != null) {
                    mediaKeywords.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        
        return mediaKeywords;
    }
    
    private List<Map<String, String>> getAllMediaKeywords(VitroRequest vreq) {
          
        String queryStr = ALL_RESEARCH_KEWORDS_QUERY;
        log.debug("All Research Keywords Query string is: " + queryStr);
        List<Map<String, String>> mediaKeywords = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("label");
                if (node != null) {
                    mediaKeywords.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        
        return mediaKeywords;
    }
}
