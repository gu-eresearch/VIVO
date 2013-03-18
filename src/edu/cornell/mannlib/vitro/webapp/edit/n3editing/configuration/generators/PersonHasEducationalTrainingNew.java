/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.generators;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Set;
import java.util.Map;

import javax.servlet.http.HttpSession;

import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.vocabulary.XSD;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;
import edu.cornell.mannlib.vitro.webapp.dao.jena.QueryUtils;


import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.dao.VitroVocabulary;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.DateTimeIntervalValidationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.DateTimeWithPrecisionVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.EditConfigurationVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ChildVClassesOptions;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.ChildVClassesWithParent;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.FieldVTwo;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.VTwo.fields.IndividualsViaVClassOptions;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.configuration.validators.AntiXssValidation;
import edu.cornell.mannlib.vitro.webapp.utils.FrontEndEditingUtils.EditMode;
import edu.cornell.mannlib.vitro.webapp.utils.generators.EditModeUtils;


import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

/**
    Form for adding an educational attainment to an individual

    Classes: 
    core:EducationalTraining - primary new individual being created
    foaf:Person - existing individual
    foaf:Organization - new or existing individual
    core:AcademicDegree - existing individual
    
    Data properties of EducationalTraining:
    core:majorField
    core:departmentOrSchool
    core:supplementalInformation
    
    Object properties (domain : range)
    
    core:educationalTraining (Person : EducationalTraining) - inverse of core:educationalTrainingOf
    core:educationalTrainingOf (EducationalTraining : Person) - inverse of core:educationalTraining
    
    core:degreeEarned (EducationalTraining : AcademicDegree) - inverse of core:degreeOutcomeOf
    core:degreeOutcomeOf (AcademicDegree : EducationalTraining) - inverse of core:degreeEarned
    
    core:organizationGrantingDegree (EducationalTraining : Organisation) - no inverse
    
    Future version
    --------------
    Classes:
    core:DateTimeValue
    core:DateTimeValuePrecision
    Object properties:
    core:dateTimeValue (EducationalTraining : DateTimeValue)
    core:dateTimePrecision (DateTimeValue : DateTimeValuePrecision)

   
    There are 4 modes that this form can be in: 
     1.  Add, there is a subject and a predicate but no position and nothing else. 
           
     2. normal edit where everything should already be filled out.  There is a subject, a object and an individual on
        the other end of the object's core:trainingAtOrganization stmt. 
     
     3. Repair a bad role node.  There is a subject, prediate and object but there is no individual on the 
        other end of the object's core:trainingAtOrganization stmt.  This should be similar to an add but the form should be expanded.
        
     4. Really bad node. multiple core:trainingAtOrganization statements.   

 * @author bdc34
 *
 */
public class PersonHasEducationalTrainingNew  extends VivoBaseGenerator implements EditConfigurationGenerator{            
	private Log log = LogFactory.getLog(PersonHasEducationalTrainingNew.class);

    //TODO: can we get rid of the session and get it form the vreq?
    public EditConfigurationVTwo getEditConfiguration(VitroRequest vreq, HttpSession session) throws Exception {
        EditConfigurationVTwo conf = new EditConfigurationVTwo();
        String subjectURI = conf.getSubjectUri();        
        initBasics(conf, vreq);
        initPropertyParameters(vreq, session, conf);
        initObjectPropForm(conf, vreq);               
        
        conf.setTemplate("personHasEducationalTrainingNew.ftl");
        
        conf.setVarNameForSubject("person");
        conf.setVarNameForPredicate("predicate");
        conf.setVarNameForObject("edTraining");
                
        conf.setN3Required( Arrays.asList( n3ForNewEdTraining, orgLabelAssertion, orgTypeAssertion ) );
        conf.setN3Optional(Arrays.asList( 
                n3ForEdTrainingToOrg, majorFieldAssertion, degreeAssertion, 
                deptAssertion, infoAssertion, 
                n3ForStart, n3ForEnd, n3ForOrgToEdTraining  ));
        
        
        conf.addNewResource("edTraining", DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("org",DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("intervalNode",DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("startNode",DEFAULT_NS_FOR_NEW_RESOURCE);
        conf.addNewResource("endNode",DEFAULT_NS_FOR_NEW_RESOURCE);
        
        //uris in scope: none   
        //literals in scope: none
        
        conf.setUrisOnform( Arrays.asList( "org", "orgType", "degree"));
        conf.setLiteralsOnForm( Arrays.asList("orgLabel","majorField","dept","info"));
		
		
		
        conf.addSparqlForExistingLiteral("orgLabel", orgLabelQuery);
        conf.addSparqlForExistingLiteral("degreeLabel", degreeLabelQuery);
        conf.addSparqlForExistingLiteral("degreeAbbrev", degreeAbbreviationQuery);
        conf.addSparqlForExistingLiteral("majorField", majorFieldQuery);
        conf.addSparqlForExistingLiteral("dept", deptQuery);
        conf.addSparqlForExistingLiteral("info", infoQuery);
        conf.addSparqlForExistingLiteral("startField-value", existingStartDateQuery);
        conf.addSparqlForExistingLiteral("endField-value", existingEndDateQuery);
		

        conf.addSparqlForExistingUris("org",orgQuery);
        conf.addSparqlForExistingUris("orgType",orgTypeQuery);
        conf.addSparqlForExistingUris("degree", degreeQuery);
        conf.addSparqlForExistingUris("intervalNode",existingIntervalNodeQuery);
        conf.addSparqlForExistingUris("startNode", existingStartNodeQuery);
        conf.addSparqlForExistingUris("endNode", existingEndNodeQuery);
        conf.addSparqlForExistingUris("startField-precision", existingStartPrecisionQuery);
        conf.addSparqlForExistingUris("endField-precision", existingEndPrecisionQuery);
        //Add sparql to include inverse property as well
        conf.addSparqlForAdditionalUrisInScope("inverseTrainingAtOrg", inverseTrainingAtOrgQuery);

        
        conf.addField( new FieldVTwo().                        
                setName("degree").
                setOptions( new IndividualsViaVClassOptions(
                        degreeClass)));

        conf.addField( new FieldVTwo().
                setName("majorField").
                setRangeDatatypeUri( XSD.xstring.toString() ).
                setValidators(list("datatype:" + XSD.xstring.toString())));
                
                
        
        //Get options for org field
        HashMap<String, String> literalOptionsMap = getEducationInstitutionMap();
    	List<List<String>> orgFieldLiteralOptions = new ArrayList<List<String>>();
    	Set<String> optionUris = literalOptionsMap.keySet();
    	for(String optionUri: optionUris) {
    		List<String> uriLabelArray = new ArrayList<String>();
    		uriLabelArray.add(optionUri);
    		uriLabelArray.add(literalOptionsMap.get(optionUri));
    		orgFieldLiteralOptions.add(uriLabelArray);
    	}


        
        conf.addField( new FieldVTwo().
                setName("org"));
                //setLiteralOptions(orgFieldLiteralOptions).
                //setObjectClassUri( orgClass ));
                //setLiteralOptions( [ "Select One" } )
        
        conf.addField( new FieldVTwo().
                setName("orgLabel").
                setRangeDatatypeUri(XSD.xstring.toString() ).
                setValidators( list("nonempty")));
                
        conf.addField( new FieldVTwo().
                setName("orgType").
                setValidators( list("nonempty")));
                //setLiteralOptions( [ "Select one" ] )
                
        conf.addField( new FieldVTwo().
                setName("dept").
                setRangeDatatypeUri( XSD.xstring.toString() ).
                setValidators(list("datatype:" + XSD.xstring.toString())));
                
        conf.addField( new FieldVTwo().
                setName("info").
                setRangeDatatypeUri( XSD.xstring.toString() ).
                setValidators(list("datatype:" + XSD.xstring.toString())));
		
        FieldVTwo startField = new FieldVTwo().
        						setName("startField");
        conf.addField(startField.                        
            setEditElement(
                    new DateTimeWithPrecisionVTwo(startField, 
                    VitroVocabulary.Precision.YEAR.uri(),
                    VitroVocabulary.Precision.NONE.uri())));
        
        FieldVTwo endField = new FieldVTwo().
								setName("endField");
        conf.addField( endField.                
                setEditElement(
                        new DateTimeWithPrecisionVTwo(endField, 
                        VitroVocabulary.Precision.YEAR.uri(),
                        VitroVocabulary.Precision.NONE.uri())));
        //Add validator
        conf.addValidator(new DateTimeIntervalValidationVTwo("startField","endField"));
        conf.addValidator(new AntiXssValidation());
        
        //Adding additional data, specifically edit mode
        addFormSpecificData(conf, vreq);
        prepare(vreq, conf);
        return conf;
    }
	
	private static String ALL_EXISTING_DEGREES_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "SELECT DISTINCT ?degree (str(?Label) as ?label) (str(?Abbreviation) as ?abbreviation)  WHERE { \n"
        + "    ?degree a core:AcademicDegree . \n"
        + "    ?degree rdfs:label ?Label . \n"
        + "    ?degree core:abbreviation ?Abbreviation . \n"
        + "} ORDER BY ?Label ";
        
    private static String ALL_EXISTING_ORGS_QUERY = ""
        + "PREFIX core: <http://vivoweb.org/ontology/core#> \n"
        + "PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#> \n"
        + "SELECT  DISTINCT ?org (str(?Label) as ?label)  WHERE { \n"
		+ " ?training a core:EducationalTraining . \n"
		+ " ?training core:trainingAtOrganization ?org . \n"
		+ " ?org rdfs:label ?Label . \n"
	+ "} \n"
	+ "ORDER BY ?Label ";    
	
	
	private List<Map<String, String>> getAllExistingDegrees(VitroRequest vreq) {
          
        String queryStr = ALL_EXISTING_DEGREES_QUERY;
        log.debug("All Degree Query string is: " + queryStr);
        List<Map<String, String>> degrees = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("label");
                if (node != null) {
                    degrees.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        
        return degrees;
    }
    
    private List<Map<String, String>> getAllExistingOrganisations(VitroRequest vreq) {
          
        String queryStr = ALL_EXISTING_ORGS_QUERY;
        log.debug("All Educational Organisations Query string is: " + queryStr);
        List<Map<String, String>> orgs = new ArrayList<Map<String, String>>();
        try {
            ResultSet results = QueryUtils.getQueryResults(queryStr, vreq);
            while (results.hasNext()) {
                QuerySolution soln = results.nextSolution();
                RDFNode node = soln.get("label");
                if (node != null) {
                    orgs.add(QueryUtils.querySolutionToStringValueMap(soln));        
                }
            }
        } catch (Exception e) {
            log.error(e, e);
        }    
        
        return orgs;
    }
	
    
    /* N3 assertions for working with educational training */
    
    final static String orgTypeAssertion =
        "?org a ?orgType .";

    final static String orgLabelAssertion =
        "?org <"+ label +"> ?orgLabel .";

    final static String degreeAssertion  =      
        "?edTraining <"+ degreeEarned +"> ?degree .\n"+
        "?degree <"+ degreeOutcomeOf +"> ?edTraining .";

    final static String majorFieldAssertion  =      
        "?edTraining <"+ majorFieldPred +"> ?majorField .";

    final static String n3ForStart =
        "?edTraining      <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode  <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToStart +"> ?startNode .\n"+
        "?startNode  <"+ type +"> <"+ dateTimeValueType +"> .\n"+
        "?startNode  <"+ dateTimeValue +"> ?startField-value .\n"+
        "?startNode  <"+ dateTimePrecision +"> ?startField-precision .";

    final static String n3ForEnd =
        "?edTraining      <"+ toInterval +"> ?intervalNode . \n"+
        "?intervalNode  <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToEnd +"> ?endNode .\n"+
        "?endNode  <"+ type +"> <"+ dateTimeValueType +"> .\n"+
        "?endNode  <"+ dateTimeValue +"> ?endField-value .\n"+
        "?endNode  <"+ dateTimePrecision +"> ?endField-precision .";

    final static String deptAssertion  =      
        "?edTraining <"+ deptPred +"> ?dept .";

    final static String infoAssertion  =      
        "?edTraining <"+ infoPred +"> ?info .";

    final static String n3ForNewEdTraining =       
        "@prefix core: <"+ vivoCore +"> .\n"+
        "?person core:educationalTraining  ?edTraining .\n"+            
        "?edTraining  a core:EducationalTraining ;\n"+
        "core:educationalTrainingOf ?person ;\n"+
        "<"+ trainingAtOrg +"> ?org .\n";

    final static String n3ForEdTrainingToOrg  =      
        "?edTraining <"+ trainingAtOrg +"> ?org .";
    
    //The inverse of the above
    final static String n3ForOrgToEdTraining  =      
        "?org ?inverseTrainingAtOrg ?edTraining .";
    /* Queries for editing an existing educational training entry */

    final static String orgQuery  =      
        "SELECT ?existingOrg WHERE {\n"+
        "?edTraining <"+ trainingAtOrg +"> ?existingOrg . }\n";

    final static String orgLabelQuery  =      
        "SELECT ?existingOrgLabel WHERE {\n"+
        "?edTraining <"+ trainingAtOrg +"> ?existingOrg .\n"+
        "?existingOrg <"+ label +"> ?existingOrgLabel .\n"+
        "}";

    /* Limit type to subclasses of foaf:Organization. Otherwise, sometimes owl:Thing or another
    type is returned and we don't get a match to the select element options. */
    final static String orgTypeQuery  =      
        "PREFIX rdfs: <"+ rdfs +">   \n"+
        "SELECT ?existingOrgType WHERE {\n"+
        "?edTraining <"+ trainingAtOrg +"> ?existingOrg .\n"+
        "?existingOrg a ?existingOrgType .\n"+
        "?existingOrgType rdfs:subClassOf <"+ orgClass +"> .\n"+
        "}";

    final static String degreeQuery  =      
        "SELECT ?existingDegree WHERE {\n"+
        "?edTraining <"+ degreeEarned +"> ?existingDegree . }";
        
    final static String degreeLabelQuery  =      
        "SELECT ?existingDegreeLabel WHERE {\n"+
        "?edTraining <"+ degreeEarned +"> ?existingDegree . \n"+
        "?existingDegree <"+ label +"> ?existingDegreeLabel .\n"+
        "}";
    
    final static String degreeAbbreviationQuery  =      
        "SELECT ?existingDegreeAbbrev WHERE {\n"+
        "?edTraining <"+ degreeEarned +"> ?existingDegree . \n"+
        "?existingDegree <http://vivoweb.org/ontology/core#abbreviation> ?existingDegreeAbbrev .\n"+
        "}";

    final static String majorFieldQuery  =  
        "SELECT ?existingMajorField WHERE {\n"+
        "?edTraining <"+ majorFieldPred +"> ?existingMajorField . }";

    final static String deptQuery  =  
        "SELECT ?existingDept WHERE {\n"+
        "?edTraining <"+ deptPred +"> ?existingDept . }";

    final static String infoQuery  =  
        "SELECT ?existingInfo WHERE {\n"+
        "?edTraining <"+ infoPred +"> ?existingInfo . }";

    final static String existingIntervalNodeQuery  =  
        "SELECT ?existingIntervalNode WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?existingIntervalNode .\n"+
        "?existingIntervalNode <"+ type +"> <"+ intervalType +"> . }";
     
    final static String existingStartNodeQuery  =  
        "SELECT ?existingStartNode WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToStart +"> ?existingStartNode . \n"+
        "?existingStartNode <"+ type +"> <"+ dateTimeValueType +"> .}";

    final static String existingStartDateQuery  =  
        "SELECT ?existingDateStart WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToStart +"> ?startNode .\n"+
        "?startNode <"+ type +"> <"+ dateTimeValueType +"> .\n"+
        "?startNode <"+ dateTimeValue +"> ?existingDateStart . }";

    final static String existingStartPrecisionQuery  =  
        "SELECT ?existingStartPrecision WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToStart +"> ?startNode .\n"+
        "?startNode <"+ type +"> <"+ dateTimeValueType +"> . \n"+
        "?startNode <"+ dateTimePrecision +"> ?existingStartPrecision . }";

    final static String existingEndNodeQuery  =  
        "SELECT ?existingEndNode WHERE { \n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToEnd +"> ?existingEndNode . \n"+
        "?existingEndNode <"+ type +"> <"+ dateTimeValueType +"> .}";

    final static String existingEndDateQuery  =  
        "SELECT ?existingEndDate WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToEnd +"> ?endNode .\n"+
        "?endNode <"+ type +"> <"+ dateTimeValueType +"> .\n"+
        "?endNode <"+ dateTimeValue +"> ?existingEndDate . }";

    final static String existingEndPrecisionQuery  =  
        "SELECT ?existingEndPrecision WHERE {\n"+
        "?edTraining <"+ toInterval +"> ?intervalNode .\n"+
        "?intervalNode <"+ type +"> <"+ intervalType +"> .\n"+
        "?intervalNode <"+ intervalToEnd +"> ?endNode .\n"+
        "?endNode <"+ type +"> <"+ dateTimeValueType +"> .\n"+
        "?endNode <"+ dateTimePrecision +"> ?existingEndPrecision . }";
    
    //Query for inverse property
    final static String inverseTrainingAtOrgQuery  =
    	  "PREFIX owl:  <http://www.w3.org/2002/07/owl#>"
			+ " SELECT ?inverseTrainingAtOrg "
			+ "    WHERE { ?inverseTrainingAtOrg owl:inverseOf <"+ trainingAtOrg +"> . } ";
    
    
  //Adding form specific data such as edit mode
	public void addFormSpecificData(EditConfigurationVTwo editConfiguration, VitroRequest vreq) {
		HashMap<String, Object> formSpecificData = new HashMap<String, Object>();
		formSpecificData.put("editMode", getEditMode(vreq).name().toLowerCase());
		formSpecificData.put("org", getEducationInstitutionMap() );
		
		List<Map<String,String>> allExistingDegrees = getAllExistingDegrees(vreq);
        formSpecificData.put("allExistingDegrees",allExistingDegrees);
        
        List<Map<String,String>> allExistingOrgs = getAllExistingOrganisations(vreq);
        formSpecificData.put("allExistingOrgs",allExistingOrgs);
		
		List<Map<String,String>> educationInstitutionsList = getEducationInstitutionsList();
        formSpecificData.put("educationInstitutionsList",educationInstitutionsList);
        
        HashMap<String, String> educationInstitutionsMap = getEducationInstitutionMap();
        formSpecificData.put("educationInstitutionsMap",educationInstitutionsMap);
		
		editConfiguration.setFormSpecificData(formSpecificData);
	}
	
	public EditMode getEditMode(VitroRequest vreq) {
		List<String> predicates = new ArrayList<String>();
		predicates.add(trainingAtOrg);
		return EditModeUtils.getEditMode(vreq, predicates);
	}
	
	public HashMap<String, String> getEducationInstitutionMap() {

		HashMap<String, String> literalOptions = new HashMap<String, String>();

		literalOptions.put("", "Select type");

        literalOptions.put("http://vivoweb.org/ontology/core#Association", "Association");

        literalOptions.put("http://vivoweb.org/ontology/core#Center", "Center");

        literalOptions.put("http://vivoweb.org/ontology/core#ClinicalOrganization", "Clinical Organisation");

        literalOptions.put("http://vivoweb.org/ontology/core#College", "College");

        literalOptions.put("http://vivoweb.org/ontology/core#Committee", "Committee");                     

        literalOptions.put("http://vivoweb.org/ontology/core#Consortium", "Consortium");

        literalOptions.put("http://vivoweb.org/ontology/core#Department", "Department");

        literalOptions.put("http://vivoweb.org/ontology/core#Division", "Division"); 

        literalOptions.put("http://purl.org/NET/c4dm/event.owl#Event", "Event"); 

        literalOptions.put("http://vivoweb.org/ontology/core#ExtensionUnit", "Extension Unit");

        literalOptions.put("http://vivoweb.org/ontology/core#Foundation", "Foundation");

        literalOptions.put("http://vivoweb.org/ontology/core#FundingOrganization", "Funding Organisation");

        literalOptions.put("http://vivoweb.org/ontology/core#GovernmentAgency", "Government Agency");

        literalOptions.put("http://vivoweb.org/ontology/core#Hospital", "Hospital");

        literalOptions.put("http://vivoweb.org/ontology/core#Institute", "Institute");

        literalOptions.put("http://vivoweb.org/ontology/core#Laboratory", "Laboratory");

        literalOptions.put("http://vivoweb.org/ontology/core#Library", "Library");

        literalOptions.put("http://vivoweb.org/ontology/core#Museum", "Museum");        

        literalOptions.put("http://xmlns.com/foaf/0.1/Organization", "Organisation");

        literalOptions.put("http://vivoweb.org/ontology/core#PrivateCompany", "Private Company");

        literalOptions.put("http://vivoweb.org/ontology/core#Program", "Program");

        literalOptions.put("http://vivoweb.org/ontology/core#Project", "Project");

        literalOptions.put("http://vivoweb.org/ontology/core#Publisher", "Publisher");

        literalOptions.put("http://vivoweb.org/ontology/core#ResearchOrganization", "Research Organisation");

        literalOptions.put("http://vivoweb.org/ontology/core#School", "School");

        literalOptions.put("http://vivoweb.org/ontology/core#Service","Service");

        literalOptions.put("http://vivoweb.org/ontology/core#Team", "Team");

        literalOptions.put("http://vivoweb.org/ontology/core#StudentOrganization", "Student Organisation");

        literalOptions.put("http://vivoweb.org/ontology/core#University", "University");

		return literalOptions;

	}
	
	public List<Map<String, String>> getEducationInstitutionsList() {
		
		List<Map<String, String>> theList = new ArrayList<Map<String, String>>();

			

		theList.add(keyValuePairToStringValueMap("", "Select type"));		
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Association", "Association"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Center", "Center"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#ClinicalOrganization", "Clinical Organisation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#College", "College"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Committee", "Committee"));                     
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Consortium", "Consortium"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Department", "Department"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Division", "Division")); 
        theList.add(keyValuePairToStringValueMap("http://purl.org/NET/c4dm/event.owl#Event", "Event")); 
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#ExtensionUnit", "Extension Unit"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Foundation", "Foundation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#FundingOrganization", "Funding Organisation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#GovernmentAgency", "Government Agency"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Hospital", "Hospital"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Institute", "Institute"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Laboratory", "Laboratory"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Library", "Library"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Museum", "Museum"));        
        theList.add(keyValuePairToStringValueMap("http://xmlns.com/foaf/0.1/Organization", "Organisation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#PrivateCompany", "Private Company"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Program", "Program"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Project", "Project"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Publisher", "Publisher"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#ResearchOrganization", "Research Organisation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#School", "School"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Service","Service"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#Team", "Team"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#StudentOrganization", "Student Organisation"));
        theList.add(keyValuePairToStringValueMap("http://vivoweb.org/ontology/core#University", "University"));

		return theList;
	}
	
	public Map<String,String> keyValuePairToStringValueMap( String key, String val ){
        Map<String,String> map = new HashMap<String,String>();
        
        //if (key != null) {
            log.debug("Adding " + key + " : " + val + " to string value map.");
            map.put(key, val);           
        //}
        return map;
    }

	
	
}
