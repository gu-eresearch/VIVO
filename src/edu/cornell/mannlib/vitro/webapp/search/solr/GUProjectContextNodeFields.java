/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr;

import java.util.ArrayList;
import java.util.List;

import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFServiceFactory;
import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

/**
 * Class that adds text from context nodes to Solr Documents for 
 * foaf:Project individuals.
 * 
 * @author bdc34
 *
 */
public class GUProjectContextNodeFields extends ContextNodeFields{
    
    static List<String> queriesForProject = new ArrayList<String>();
    
    public GUProjectContextNodeFields(RDFServiceFactory rdfServiceFactory){        
        super(queriesForProject, rdfServiceFactory);
    }
      
  protected static final String prefix = 
        "prefix owl: <http://www.w3.org/2002/07/owl#> "
      + " prefix vitroDisplay: <http://vitro.mannlib.cornell.edu/ontologies/display/1.1#>  "
      + " prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#>  "
      + " prefix core: <http://vivoweb.org/ontology/core#>  "
      + " prefix foaf: <http://xmlns.com/foaf/0.1/> "
      + " prefix rdfs:  <http://www.w3.org/2000/01/rdf-schema#> "
      + " prefix localNav: <http://vitro.mannlib.cornell.edu/ns/localnav#>  "
      + " prefix bibo: <http://purl.org/ontology/bibo/>  "
      + " prefix afn: <http://jena.hpl.hp.com/ARQ/function#>  "
      + " prefix guhubext: <http://griffith.edu.au/ontology/hubextensions/>  "
      + " prefix fn:  <http://www.w3.org/2005/xpath-functions#>  ";
  

  //queries for foaf:Project
  static {
      

        queriesForProject.add(prefix + 
				"SELECT DISTINCT  (str(?PersonLabel) as ?principalInvestigatorRoleOf)  " +
				"WHERE { " +
				"?uri core:relatedRole ?c . " + 
				"	?c rdf:type core:Role ; core:principalInvestigatorRoleOf ?Person . " +
				"	?Person rdfs:label ?PersonLabel . " + 
				"	LET (?prop := \"principalInvestigatorRoleOf\") " +
				" }");
		
		queriesForProject.add(prefix + 
				"SELECT DISTINCT  (str(?PersonLabel) as ?investigatorRoleOf)  " +
				"WHERE { " +
				"?uri core:relatedRole ?c . " + 
				"	?c rdf:type core:Role ; core:investigatorRoleOf ?Person . " +
				"	?Person rdfs:label ?PersonLabel . " + 
				"	LET (?prop := \"investigatorRoleOf\") " +
				" }");
		
		
		
		queriesForProject.add(prefix + 
		"SELECT DISTINCT    (afn:substring(str(?StartYear),0,4) as ?startYear) (afn:substring(str(?EndYear),0,4) as ?endYear)" +
		"		WHERE {  " +
		"		?uri core:dateTimeInterval ?c .  " +
		"			?c core:start ?valueStart . ?valueStart core:dateTime ?StartYear .  " +
		"           OPTIONAL { ?c core:end ?valueEnd .  ?valueEnd core:dateTime ?EndYear .  }" +
		"		 } LIMIT 1");
		
		
		queriesForProject.add(prefix + 
		"SELECT DISTINCT   (fn:substring(str(?StartMonth),6,2) as ?startMonth) " +
		"		WHERE {  " +
		"		?uri core:dateTimeInterval ?c .  " +
		"			?c core:start ?valueStart .  " +
		"			?valueStart core:dateTime ?StartMonth .  " +
		"			LET (?prop := \"startMonth\")  " +
		"		 } LIMIT 1");
		
		queriesForProject.add(prefix + 
		"SELECT DISTINCT   (fn:substring(str(?EndMonth),6,2) as ?endMonth) " +
		"		WHERE {  " +
		"		?uri core:dateTimeInterval ?c .  " +
		"			?c core:end ?valueEnd .  " +
		"			?valueEnd core:dateTime ?EndMonth .  " +
		"			LET (?prop := \"endMonth\")  " +
		"		 } LIMIT 1");
		
		
        
       
    }

}
