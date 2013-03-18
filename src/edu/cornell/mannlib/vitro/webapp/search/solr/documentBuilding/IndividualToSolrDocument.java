
/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.HashSet;
import java.util.HashMap;
import java.util.LinkedHashMap;
import java.util.Collections;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.solr.common.SolrDocument;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.common.SolrInputField;
import org.joda.time.DateTime;
import org.jsoup.Jsoup;
import org.openrdf.model.impl.URIImpl;

import com.hp.hpl.jena.query.Query;
import com.hp.hpl.jena.query.QueryExecution;
import com.hp.hpl.jena.query.QueryExecutionFactory;
import com.hp.hpl.jena.query.QueryFactory;
import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.query.Syntax;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;
import com.hp.hpl.jena.shared.Lock;

import com.hp.hpl.jena.vocabulary.OWL;

import edu.cornell.mannlib.vitro.webapp.beans.DataPropertyStatement;
import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.beans.IndividualImpl;
import edu.cornell.mannlib.vitro.webapp.beans.ObjectPropertyStatement;
import edu.cornell.mannlib.vitro.webapp.beans.VClass;
import edu.cornell.mannlib.vitro.webapp.search.IndexingException;
import edu.cornell.mannlib.vitro.webapp.search.VitroSearchTermNames;

public class IndividualToSolrDocument {
    private Model model;
        
    public static final Log log = LogFactory.getLog(IndividualToSolrDocument.class.getName());
    
    public static VitroSearchTermNames term = new VitroSearchTermNames();              
    
    protected final String label = "http://www.w3.org/2000/01/rdf-schema#label";
    
    protected List<DocumentModifier> documentModifiers = new ArrayList<DocumentModifier>();

    protected List<SearchIndexExcluder> excludes;
        
    public IndividualToSolrDocument(List<SearchIndexExcluder> excludes, List<DocumentModifier> docModifiers, Model model){
        this.excludes = excludes;
        this.documentModifiers = docModifiers;
        this.model = model;
    }    

	@SuppressWarnings("static-access")
    public SolrInputDocument translate(Individual ind) throws IndexingException{
        try{    	            	      	        	        	
        	String excludeMsg = checkExcludes( ind );
        	if( excludeMsg != DONT_EXCLUDE){
        	    log.debug(ind.getURI() + " " + excludeMsg);
        	    return null;
        	}        	    
        		            
        	SolrInputDocument doc = new SolrInputDocument();                    	
        	
            //DocID
            doc.addField(term.DOCID, getIdForUri( ind.getURI() ) );
            
            //vitro id
            doc.addField(term.URI, ind.getURI());
                    
    		//get label from ind
    		addLabel(ind, doc);
    		
        	//add classes, classgroups get if prohibited because of its class
            StringBuffer classPublicNames = new StringBuffer("");
        	addClasses(ind, doc, classPublicNames);
        	        	        	        	
        	// collecting URIs and rdfs:labels of objects of statements         	
        	StringBuffer objectNames = new StringBuffer("");        	
        	StringBuffer addUri = new StringBuffer("");           	
        	addObjectPropertyText(ind, doc, objectNames, addUri);        	                 	                                           	     
                        
            //time of index in msec past epoch
            doc.addField(term.INDEXEDTIME, new Long( (new DateTime()).getMillis() ) ); 
                        
            addAllText( ind, doc, classPublicNames, objectNames );
               
            //boost for entity
            if(ind.getSearchBoost() != null && ind.getSearchBoost() != 0) {            	
                doc.setDocumentBoost(ind.getSearchBoost());                    
            }    
            
            runAdditionalDocModifers(ind,doc,addUri);            
            
            return doc;
        }catch(SkipIndividualException ex){
            //indicates that this individual should not be indexed by returning null
            log.debug(ex);
            return null;
        }catch(Exception th){
            //Odd exceptions can get thrown on shutdown
            if( log != null )
                log.error(th,th);
            return null;
        }
    }
    
           
	protected String checkExcludes(Individual ind) {
        for( SearchIndexExcluder excluder : excludes){
            try{
                String msg = excluder.checkForExclusion(ind);
                if( msg != DONT_EXCLUDE)
                    return msg;
            }catch (Exception e) {
                return e.getMessage();
            }
        }	    
	    return DONT_EXCLUDE;
    }

	protected Map<String,Long> docModClassToTime = new HashMap<String,Long>();
	protected long docModCount =0;
	
    protected void runAdditionalDocModifers( Individual ind, SolrInputDocument doc, StringBuffer addUri ) 
    throws SkipIndividualException{
        //run the document modifiers
        if( documentModifiers != null && !documentModifiers.isEmpty()){
        	docModCount++;        	
            for(DocumentModifier modifier: documentModifiers){
            	
            	long start = System.currentTimeMillis();
            	
                modifier.modifyDocument(ind, doc, addUri);
                
                if( log.isDebugEnabled()){                	
	                long delta = System.currentTimeMillis() - start;
	                synchronized(docModClassToTime){
	                	Class clz = modifier.getClass();	                	
	                	if( docModClassToTime.containsKey( clz.getName() )){
	                		Long time = docModClassToTime.get(clz.getName() );
	                		docModClassToTime.put(clz.getName(), time + delta);	                		
	                	}else{
	                		docModClassToTime.put(clz.getName(), delta);
	                	}
	                }
	                if( docModCount % 200 == 0 ){
	                	log.debug("DocumentModifier timings");
	                	for( Entry<String, Long> entry: docModClassToTime.entrySet()){	                		
	                		log.debug("average msec to run " + entry.getKey() + ": " + (entry.getValue()/docModCount));                		
	                	}
	                }
                }
            }
        }        
    }
    
    protected void addAllText(Individual ind, SolrInputDocument doc, StringBuffer classPublicNames, StringBuffer objectNames) {
        String t=null;
        //ALLTEXT, all of the 'full text'
        StringBuffer allTextValue = new StringBuffer();
        
        getDataPropertiesByQuery(ind, doc);
        
        /*
        //collecting data property statements
        List<DataPropertyStatement> dataPropertyStatements = ind.getDataPropertyStatements();
        if (dataPropertyStatements != null) {
            Iterator<DataPropertyStatement> dataPropertyStmtIter = dataPropertyStatements.iterator();
            while (dataPropertyStmtIter.hasNext()) {
                DataPropertyStatement dataPropertyStmt =  dataPropertyStmtIter.next();
                if(dataPropertyStmt.getDatapropURI().equals(label)){ // we don't want label to be added to alltext
                    continue;
                } else if(dataPropertyStmt.getDatapropURI().equals("http://vivoweb.org/ontology/core#preferredTitle")){
                	//add the preferredTitle field
                	String preferredTitle = null;
                	doc.addField(term.PREFERRED_TITLE, ((preferredTitle=dataPropertyStmt.getData()) == null)?"":preferredTitle);
                	log.debug("Preferred Title: " + dataPropertyStmt.getData());
                }
                allTextValue.append(" ");
                allTextValue.append(((t=dataPropertyStmt.getData()) == null)?"":t);
            }
        }
         */
        allTextValue.append(objectNames.toString());
        
        allTextValue.append(' ');                      
        allTextValue.append(classPublicNames);
        
        try {
            String stripped = Jsoup.parse(allTextValue.toString()).text();
            allTextValue.setLength(0);
            allTextValue.append(stripped);
        } catch(Exception e) {
            log.debug("Could not strip HTML during search indexing. " + e);
        }
                
        String alltext = allTextValue.toString();
        
        doc.addField(term.ALLTEXT, alltext);
        doc.addField(term.ALLTEXTUNSTEMMED, alltext);
        doc.addField(term.ALLTEXT_PHONETIC, alltext);
        
    }





    /**
     * Get the rdfs:labes for objects of statements and put in objectNames.
     *  Get the URIs for objects of statements and put in addUri.
     */
    protected void addObjectPropertyText(Individual ind, SolrInputDocument doc,
            StringBuffer objectNames, StringBuffer addUri) {
        List<ObjectPropertyStatement> objectPropertyStatements = ind.getObjectPropertyStatements();
        if (objectPropertyStatements != null) {
            Iterator<ObjectPropertyStatement> objectPropertyStmtIter = objectPropertyStatements.iterator();
            while (objectPropertyStmtIter.hasNext()) {
                ObjectPropertyStatement objectPropertyStmt = objectPropertyStmtIter.next();
                if( "http://www.w3.org/2002/07/owl#differentFrom".equals(objectPropertyStmt.getPropertyURI()) ){
                    continue;
                }
                try {
                    objectNames.append(" ");
                    String t=null;
                    t = objectPropertyStmt.getObject().getRdfsLabel();
                    //a.solland: adding each populated data property as a separate field in the solr document
                    if (t != null) {
                        objectNames.append(t);
						 
                        //add fields for object properties
                        String op_localName = objectPropertyStmt.getProperty().getLocalName();								
                        log.debug("adding op_ field for: " + op_localName);
                        doc.addField("op_"+op_localName, objectPropertyStmt.getObjectURI() );
                        doc.addField("op_label_"+op_localName, t );		
						
                    }               
                    
                    addUri.append(" ");
                    addUri.append(((t=objectPropertyStmt.getObject().getURI()) == null)?"":t);
                } catch (Exception e) { 
                     log.debug("could not index name of related object: " + e.getMessage());
                }
            }
        }        
    }

    /**
     * Adds the info about the classes that the individual is a member
     * of, classgroups and checks if prohibited.
     * @param classPublicNames 
     * @returns true if prohibited from search
     * @throws SkipIndividualException 
     */
    protected void addClasses(Individual ind, SolrInputDocument doc, StringBuffer classPublicNames) throws SkipIndividualException{
        ArrayList<String> superClassNames = null;        
        
        List<VClass> vclasses = ind.getVClasses(false);
        if( vclasses == null || vclasses.isEmpty() ){
            throw new SkipIndividualException("Not indexing because individual has no classes");
        }        
                
        for(VClass clz : vclasses){
            if(clz.getURI() == null){
                continue;
            }else if(OWL.Thing.getURI().equals(clz.getURI())){
                //don't add owl:Thing as the type in the index
                continue;
            } else {                                
                if( clz.getSearchBoost() != null){                	
                    doc.setDocumentBoost(doc.getDocumentBoost() + clz.getSearchBoost());
                }
                
                doc.addField(term.RDFTYPE, clz.getURI());
                
                if(clz.getLocalName() != null){
                    doc.addField(term.CLASSLOCALNAME, clz.getLocalName());
                    doc.addField(term.CLASSLOCALNAMELOWERCASE, clz.getLocalName().toLowerCase());
                }
                
                if(clz.getName() != null){
                    classPublicNames.append(" ");
                    classPublicNames.append(clz.getName());
                }
                
                //Add the Classgroup URI to a field
                if(clz.getGroupURI() != null){
                    URIImpl theURI = new URIImpl(clz.getGroupURI());
                    
                    String classGroupLocalName = theURI.getLocalName();
                    log.debug("adding classgroup info - "+term.CLASSGROUP_URI+": " + classGroupLocalName);
                    doc.addField(term.CLASSGROUP_URI,classGroupLocalName);
                }               
            }
        }                                                
    }
        
    protected void addLabel(Individual ind, SolrInputDocument doc) {
        String value = "";
        String label = ind.getRdfsLabel();
        if (label != null) {
            value = label;
        } else {
            value = ind.getLocalName();
        }            

        doc.addField(term.NAME_RAW, value);
        doc.addField(term.NAME_LOWERCASE_SINGLE_VALUED,value);
        
        // NAME_RAW will be copied by solr into the following fields:
        // NAME_LOWERCASE, NAME_UNSTEMMED, NAME_STEMMED, NAME_PHONETIC, AC_NAME_UNTOKENIZED, AC_NAME_STEMMED
    }
    
    public Object getIndexId(Object obj) {
        throw new Error("IndiviudalToSolrDocument.getIndexId() is unimplemented");        
    }
    
    public String getIdForUri(String uri){
        if( uri != null ){
            return  "vitroIndividual:" + uri;
        }else{
            return null;
        }
    }
    
    public String getQueryForId(String uri ){
        return term.DOCID + ':' + getIdForUri(uri);
    }
    
    public Individual unTranslate(Object result) {
        Individual ent = null;

        if( result != null && result instanceof SolrDocument){
            SolrDocument hit = (SolrDocument) result;
            String uri= (String) hit.getFirstValue(term.URI);

            ent = new IndividualImpl();
            ent.setURI(uri);
        }
        return ent;
    }
    
    public void shutdown(){
        for(DocumentModifier dm: documentModifiers){
            try{
                dm.shutdown();
            }catch(Exception e){
                if( log != null)
                    log.debug(e,e);
            }
        }
    }

    protected static final String DONT_EXCLUDE =null;
    
    public void getDataPropertiesByQuery( Individual individual, SolrInputDocument doc ){
        StringBuffer propertyValues = new StringBuffer();
        SolrInputField field = doc.getField(VitroSearchTermNames.ALLTEXT);
        
        String query =
            "SELECT ?prop ?object\n"+
            "WHERE {\n"+
            "?subject ?prop ?object .\n"+
            "FILTER (isLiteral(?object))\n"+
            "}\n";
        
        QuerySolutionMap initialBinding = new QuerySolutionMap();
        Resource uriResource = ResourceFactory.createResource(individual.getURI());        
        initialBinding.add("subject", uriResource);
        HashMap<String, SolrInputField> dataPropertyHash = new HashMap<String, SolrInputField>();
        
        Query sparqlQuery = QueryFactory.create( query, Syntax.syntaxARQ);
        
        this.model.getLock().enterCriticalSection(Lock.READ);
        try{
            QueryExecution qExec = QueryExecutionFactory.create(sparqlQuery, model, initialBinding);
            try{                
                ResultSet results = qExec.execSelect();    
                
				
                while(results.hasNext()) {                    
                    QuerySolution soln = results.nextSolution();    
                    String familyName = "";
                    String givenName = "";
                    
                    
                    Iterator<String> iter =  soln.varNames() ;
                    
                    RDFNode objectNode 		= soln.get("object");
                    RDFNode propertyNode 	= soln.get("prop");
                    
                    if (objectNode != null && propertyNode != null ) {
                        String label = objectNode.asLiteral().getString();
                        String propLocalName = propertyNode.asResource().getLocalName();
                        //log.info(label);
                        try {
                            if (label != null && propLocalName != null){

                                String solrFieldName = "dp_" + propLocalName;
                                //log.info(solrFieldName + " is :"+label);
								
                                SolrInputField labelField = new SolrInputField(solrFieldName);
                                labelField.setValue(label, 0);
                                dataPropertyHash.put(solrFieldName, labelField);
								
								/*
								if("issued".equals(propLocalName) ) {
									doc.addField("op_context_startYear", label );
									doc.addField("op_context_endYear", label );
								}
								if("familyName".equals(propLocalName) && familyName.equals("") ) {
									familyName = label;
								} else if("givenName".equals(propLocalName) && givenName.equals("")) {
									givenName = label;
								}
								
								
								if("label".equals(propLocalName) ) {
									if (!familyName.equals("") && !givenName.equals("") ) {
										doc.addField("dp_nameLowercase", familyName.toLowerCase()+givenName.toLowerCase() );
										doc.addField("dp_nameLowercaseSingleValued", familyName.toLowerCase()+givenName.toLowerCase() );
									} else {
										doc.addField("dp_nameLowercase", label.toLowerCase() );
										doc.addField("dp_nameLowercaseSingleValued", label.replaceAll(" ","").toLowerCase() );
									}
									 
								}
								
								
								if ( !doc.containsKey(solrFieldName) ) {
									doc.addField(solrFieldName, label);
								}
								*/
                            }
                        } catch (Exception e) {
                            log.info("could not index name of related object: " + e.getMessage());
                        }
                    }
                    
                }
                if( dataPropertyHash.containsKey("dp_issued")  ) {
                    String fieldValue = (String)dataPropertyHash.get("dp_issued").getValue();
                	
                    SolrInputField startYearField = new SolrInputField("op_context_startYear");
                    startYearField.setValue(fieldValue, 0);
                    dataPropertyHash.put("op_context_startYear", startYearField);
                    
                    SolrInputField endYearField = new SolrInputField("op_context_endYear");
                    endYearField.setValue(fieldValue, 0);
                    dataPropertyHash.put("op_context_endYear", endYearField);			
                    
                    //dataPropertyHash.put("op_context_startYear", dataPropertyHash.get("issued") );
                    //dataPropertyHash.put("op_context_endYear", dataPropertyHash.get("issued") );
                }
                if( dataPropertyHash.containsKey("dp_familyName") && dataPropertyHash.containsKey("dp_givenName")  ) { //its a person
                    String familyNameValue 	= (String)dataPropertyHash.get("dp_familyName").getValue();
                    String givenNameValue 	= (String)dataPropertyHash.get("dp_givenName").getValue();
                	
                    String nameLowerCase = familyNameValue.toLowerCase() + " " + givenNameValue.toLowerCase();
                	
                	
                	
                    SolrInputField nameLowerCaseField = new SolrInputField("dp_nameLowercase");
                    nameLowerCaseField.setValue(nameLowerCase, 0);
                    dataPropertyHash.put("dp_nameLowercase", nameLowerCaseField);
					
                    SolrInputField nameLowerCaseSingleValuedField = new SolrInputField("dp_nameLowercaseSingleValued");
                    nameLowerCaseSingleValuedField.setValue(nameLowerCase.replaceAll(" ","") , 0);
                    dataPropertyHash.put("dp_nameLowercaseSingleValued", nameLowerCaseSingleValuedField);
                	
                    //dataPropertyHash.put("dp_nameLowercase", dataPropertyHash.get("familyName").toLowerCase()+dataPropertyHash.get("givenName").toLowerCase() );
                    //dataPropertyHash.put("dp_nameLowercaseSingleValued", dataPropertyHash.get("familyName").toLowerCase()+dataPropertyHash.get("givenName").toLowerCase() );
                } else { //if not a person
                    if ( dataPropertyHash.containsKey("dp_label") ) {
                        String labelValue = (String)dataPropertyHash.get("dp_label").getValue();
						
                        SolrInputField nameLowerCaseField = new SolrInputField("dp_nameLowercase");
                        nameLowerCaseField.setValue(labelValue.toLowerCase(), 0);
                        dataPropertyHash.put("dp_nameLowercase", nameLowerCaseField);
						
                        SolrInputField nameLowerCaseSingleValuedField = new SolrInputField("dp_nameLowercaseSingleValued");
                        nameLowerCaseSingleValuedField.setValue(labelValue.replaceAll(" ","").toLowerCase() , 0);
                        dataPropertyHash.put("dp_nameLowercaseSingleValued", nameLowerCaseSingleValuedField);
						
                        //dataPropertyHash.put("dp_nameLowercase", label.toLowerCase());
                        //dataPropertyHash.put("dp_nameLowercaseSingleValued", label.replaceAll(" ","").toLowerCase() );
                    }
					
                }
					 
				
                //put all properties to document
                doc.putAll(dataPropertyHash);
            } catch(Throwable t){
                log.error(t,t);
            } finally{
                qExec.close();
            } 
        }finally{
            model.getLock().leaveCriticalSection();
        }
        
        
    }
}
