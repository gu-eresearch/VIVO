/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr;

import java.util.ArrayList;
import java.util.List;

import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFServiceFactory;
import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

/**
 * Class that adds text from context nodes to Solr Documents for 
 * foaf:Group individuals.
 * 
 * @author bdc34
 *
 */
public class GUGroupContextNodeFields extends ContextNodeFields{
    
    static List<String> queriesForGroup = new ArrayList<String>();
    
    public GUGroupContextNodeFields(RDFServiceFactory rdfServiceFactory){        
        super(queriesForGroup, rdfServiceFactory);
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
  

  //queries for foaf:Group
  static {
      
		
		queriesForGroup.add(prefix + 
				"SELECT DISTINCT   (str(?PersonLabel) as ?primaryAffiliationRoleOf) " +
				"WHERE { " +
				"?uri core:relatedRole ?c . " + 
				"	?c guhubext:primaryAffiliationRoleOf ?Person . " +
				"	?Person rdfs:label ?PersonLabel . " + 
				"	LET (?prop := \"primaryAffiliationRoleOf\") " +
				" }");
		
		queriesForGroup.add(prefix + 
				"SELECT DISTINCT  (str(?PersonLabel) as ?memberRoleOf)  " +
				"WHERE { " +
				"?uri core:relatedRole ?c . " + 
				"	?c core:memberRoleOf ?Person . " +
				"	?Person rdfs:label ?PersonLabel . " + 
				"	LET (?prop := \"memberRoleOf\") " +
				" }");
		
		queriesForGroup.add(prefix + 
				" SELECT DISTINCT  (str(?OrganizationLabel) as ?hasSubOrganization)  " +
				" WHERE { " +
				" ?uri rdf:type foaf:Organization  ; core:hasSubOrganization ?c .  " +
				"	OPTIONAL{?c rdfs:label ?OrganizationLabel . } " +
				"	LET (?prop := \"hasSubOrganization\") " +
				" } ");
        
       
    }

}
