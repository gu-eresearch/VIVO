/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr;

import java.util.ArrayList;
import java.util.List;

import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFServiceFactory;
import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

/**
 * Class that adds text from context nodes to Solr Documents for 
 * core:InformationResource individuals.
 * 
 * @author bdc34
 *
 */
public class GUInformationResourceContextNodeFields extends ContextNodeFields{
    
    static List<String> queriesForInformationResource = new ArrayList<String>();
    
    public GUInformationResourceContextNodeFields(RDFServiceFactory rdfServiceFactory){        
        super(queriesForInformationResource, rdfServiceFactory);
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
  

  //queries for core:InformationResource
  static {
      
        /* linked author labels */

        queriesForInformationResource
                .add(prefix
                        + "SELECT (str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {"
                        + " ?uri rdf:type core:InformationResource . "
                        + "?uri core:informationResourceInAuthorship ?a . ?a core:linkedAuthor ?b ."
                        + "?b rdfs:label ?ContextNodeProperty .}");

        /* features */
        
        queriesForInformationResource
                .add(prefix
                        + "SELECT (str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {"
                        + "?uri rdf:type core:InformationResource . "
                        + "?uri core:features ?i . ?i rdfs:label ?ContextNodeProperty ."
                        + "}");

        /* editor */ 
        
        queriesForInformationResource
                .add(prefix
                        + "SELECT (str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {"
                        + "?uri rdf:type core:InformationResource . "
                        + "?uri bibo:editor ?e . ?e rdfs:label ?ContextNodeProperty  ."
                        + "}");

        /* subject area */
        
        queriesForInformationResource
                .add(prefix
                        + "SELECT (str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {" 
                        + "?uri rdf:type core:InformationResource . "
                        + "?uri core:hasSubjectArea ?f . ?f core:researchAreaOf ?h . ?h rdfs:label ?ContextNodeProperty ." 
                        + "}");    
        
        queriesForInformationResource.add(prefix +
				"SELECT DISTINCT   (str(?Author) as ?linkedAuthorURI) "
				+ " WHERE { "
				+ " ?uri core:informationResourceInAuthorship ?authorShip . "
				+ " ?authorShip core:linkedAuthor ?Author . "
				+ "  LET (?prop := \"linkedAuthorURI\")  "
				+ "  } ");
    }

}
