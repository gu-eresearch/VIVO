/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr;

import java.util.ArrayList;
import java.util.List;

import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFServiceFactory;
import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

import edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding.ContextNodeFields;

/**
 * Class that adds text from context nodes to Solr Documents for 
 * foaf:Agent individuals.
 */
public class GUPersonContextNodeFields extends ContextNodeFields{
    
    static List<String> queriesForAgent = new ArrayList<String>();    
    
    public GUPersonContextNodeFields(RDFServiceFactory rdfServiceFactory){        
        super(queriesForAgent,rdfServiceFactory);
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
  

  //queries for foaf:Agent
  static {
      
      /*  Position */
    queriesForAgent.add(prefix +
            "SELECT " +
            "(str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Position . " +
            " ?c core:hrJobTitle ?ContextNodeProperty . }");
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Position . " +
            " ?c core:involvedOrganizationName ?ContextNodeProperty . }");       
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Position . " +
            " ?c core:positionInOrganization ?i . ?i rdfs:label ?ContextNodeProperty . }");
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?contextNodeProperty) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Position . " +
            " ?c core:titleOrRole ?ContextNodeProperty .  }");
    
    /* HR Job Title */
    
    queriesForAgent.add(prefix +
            "SELECT " +
            "(str(?HRJobTitle) as ?hrJobTitle)  " +
            "(str(?InvolvedOrganizationName) as ?involvedOrganizationName) " +
            "(str(?PositionInOrganization) as ?positionInOrganization) " +
            "(str(?TitleOrRole) as ?titleOrRole) WHERE {" 
            
            + "?uri rdf:type foaf:Agent  ; ?b ?c . "
            + " ?c rdf:type core:Position . "
            
            + " OPTIONAL { ?c core:hrJobTitle ?HRJobTitle . } . "
            + " OPTIONAL { ?c core:involvedOrganizationName ?InvolvedOrganizationName . } ."            
            + " OPTIONAL { ?c core:positionInOrganization ?i . ?i rdfs:label ?PositionInOrganization .  } . "
            + " OPTIONAL { ?c core:titleOrRole ?TitleOrRole . } . "
            + " }");
    
    /* Advisor */
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?advisee) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Relationship . " +
            " ?c core:advisee ?d . ?d rdfs:label ?ContextNodeProperty . }");
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?degreeCandidacy) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Relationship . " +
            " ?c core:degreeCandidacy ?e . ?e rdfs:label ?ContextNodeProperty . }");
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?label) as ?adviseeLabel) WHERE {" +
            " ?uri rdf:type foaf:Agent  ." +            
            " ?c rdf:type core:Relationship . " +
            " ?c core:advisor ?uri . " +
            " ?c core:advisee ?d . ?d rdfs:label ?label .}" );
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?label) as ?advisorLabel) WHERE {" +
            " ?uri rdf:type foaf:Agent  ." +            
            " ?c rdf:type core:Relationship . " +
            " ?c core:advisee ?uri . " +
            " ?c core:advisor ?d . ?d rdfs:label ?label .}" );
    
    /* Author */
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?linkedAuthorLabel) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Relationship . " +
            " ?c core:linkedAuthor ?f . " +            
            " ?f rdfs:label ?ContextNodeProperty . " +
            " FILTER( ?f != ?uri  ) " +
            "}");
    
    queriesForAgent.add(prefix +        "SELECT " +
            "(str(?ContextNodeProperty) as ?linkedInformationResourceLabel) WHERE {" +
            " ?uri rdf:type foaf:Agent  ; ?b ?c . " +
            " ?c rdf:type core:Relationship . " +
            " ?c core:linkedInformationResource ?h . ?h rdfs:label ?ContextNodeProperty . }");
    
    /* Award */        

    queriesForAgent.add(prefix +
            "SELECT " +
            "(str(?AwardLabel) as ?awardLabel) " +
            "(str(?AwardConferredBy) as ?awardConferredBy)  " +
            "(str(?Description) as ?description)   " +                        
            "WHERE {"            
            + " ?uri rdf:type foaf:Agent  ; ?b ?c . "
            + " ?c rdf:type core:AwardReceipt . "            
            + " OPTIONAL { ?c rdfs:label ?AwardLabel . } . "
            + " OPTIONAL { ?c core:awardConferredBy ?d . ?d rdfs:label ?AwardConferredBy . } . "
            + " OPTIONAL { ?c core:description ?Description . } . "
            + " }");
    
    /* Role In Organization */
    
    queriesForAgent.add(prefix +
            "SELECT (str(?OrganizationLabel) as ?organizationLabel)  WHERE {" 
            + "?uri rdf:type foaf:Agent  ; ?b ?c . "
            + " ?c rdf:type core:Role ; core:roleIn ?Organization ."
            + " ?Organization rdfs:label ?OrganizationLabel . "
            + " }");    
                
    /* Academic Degree / Educational Training */
    
    queriesForAgent.add(prefix + 
            "SELECT  " +
            "(str(?AcademicDegreeLabel) as ?academicDegreeLabel) " +
            "(str(?AcademicDegreeAbbreviation) as ?academicDegreeAbbreviation) " +
            "(str(?MajorField) as ?majorField) " +
            "(str(?DepartmentOrSchool) as ?departmentOrSchool) " +
            "(str(?TrainingAtOrganizationLabel) as ?trainingAtOrganizationLabel) WHERE {"
                
                + " ?uri rdf:type foaf:Agent ; ?b ?c . "
                + " ?c rdf:type core:EducationalTraining . "
                  
                +  "OPTIONAL { ?c core:degreeEarned ?d . ?d rdfs:label ?AcademicDegreeLabel ; core:abbreviation ?AcademicDegreeAbbreviation . } . "
                +  "OPTIONAL { ?c core:majorField ?MajorField .} ."           
                + " OPTIONAL { ?c core:departmentOrSchool ?DepartmentOrSchool . }"            
                + " OPTIONAL { ?c core:trainingAtOrganization ?e . ?e rdfs:label ?TrainingAtOrganizationLabel . } . " 
                +"}");
                
     queriesForAgent.add(prefix + 		"SELECT DISTINCT" +
				"(afn:localname(?b) as ?prop)  (str(?ContextNodeProperty) as ?contextNodeProperty) (str(?ContextNodeProperty) as ?objLabel) WHERE {" +
				"?uri rdf:type foaf:Agent  ; ?b ?c . " +
				" ?c rdf:type core:Relationship . " +
				" ?c core:linkedInformationResource ?h . ?h rdfs:label ?ContextNodeProperty . }");    
	queriesForAgent.add(prefix +
				" SELECT DISTINCT ?prop (str(?MostSpecificTypeLabel) as ?mostSpecificTypeLabel) (str(?MostSpecificTypeLabel) as ?objLabel) WHERE { "
				+ " ?uri <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#mostSpecificType> ?c . "
				+ " ?c rdfs:label ?MostSpecificTypeLabel . "
				+ " LET (?prop := \"mostSpecificType\") "
				+ " } LIMIT 1 ");
    queriesForAgent.add(prefix + 
				"SELECT DISTINCT  (str(?GroupLabel) as ?hasMemberRole) " +
				"WHERE { " +
				"?uri core:hasMemberRole ?c . " + 
				"	?c core:roleIn ?Group . " +
				"	?Group rdfs:label ?GroupLabel . " + 
				"	LET (?prop := \"hasMemberRole\") " +
				" }");
    
    queriesForAgent.add(prefix + 
				"SELECT DISTINCT  (str(?GroupLabel) as ?hasMemberRole) (str(?GroupLabel) as ?hasPrimaryAffiliationRole) " +
				"WHERE { " +
				"?uri guhubext:hasPrimaryAffiliationRole ?c . " + 
				"	?c core:roleIn ?Group . " +
				"	?Group rdfs:label ?GroupLabel . " + 
				" }");
        
    queriesForAgent.add(prefix +
            "SELECT DISTINCT (str(?areaLabel) as ?allResearchAreas)  "
            + " WHERE { "
            + " { ?uri core:hasSubjectArea ?area . ?area rdfs:label ?areaLabel .   } "
            + " UNION { ?uri core:hasResearchArea ?area . ?area rdfs:label ?areaLabel .   } "
            + " UNION { ?uri guhubext:hasMediaKeyword ?area . ?area rdfs:label ?areaLabel .   } "
            + " LET (?prop := \"allResearchAreas\") "
            + "  } ");				
            
     queriesForAgent.add(prefix +
            "SELECT (str(?ProjectLabel) as ?projectLabel)  WHERE {" 
            + "?uri core:hasInvestigatorRole ?role . "
            + " ?role rdf:type core:Role ."
            + " ?role core:roleIn ?proj . "
            + " ?proj rdfs:label ?ProjectLabel . "
            + " }");           
   		        
				
				
  }
}
