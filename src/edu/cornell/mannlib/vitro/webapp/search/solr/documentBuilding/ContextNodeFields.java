/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding;

import java.util.ArrayList;
import java.util.Collection;
import java.util.Iterator;
import java.util.List;

import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;
import org.apache.solr.common.SolrInputDocument;
import org.apache.solr.common.SolrInputField;

import com.hp.hpl.jena.query.QuerySolution;
import com.hp.hpl.jena.query.QuerySolutionMap;
import com.hp.hpl.jena.query.ResultSet;
import com.hp.hpl.jena.rdf.model.RDFNode;
import com.hp.hpl.jena.rdf.model.ResourceFactory;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFService;
import edu.cornell.mannlib.vitro.webapp.rdfservice.RDFServiceFactory;
import edu.cornell.mannlib.vitro.webapp.rdfservice.impl.RDFServiceUtils;
import edu.cornell.mannlib.vitro.webapp.search.VitroSearchTermNames;

/**
 * DocumentModifier that will run SPARQL queries for an
 * Individual and add all the columns from all the rows
 * in the solution set to the ALLTEXT field.
 *  
 * @author bdc34
 *
 */
public class ContextNodeFields implements DocumentModifier{
    protected List<String> queries = new ArrayList<String>();
    protected boolean shutdown = false;    
    protected Log log = LogFactory.getLog(ContextNodeFields.class);   
    protected RDFServiceFactory rdfServiceFactory;
       
    /**
     * Construct this with a model to query when building Solr Documents and
     * a list of the SPARQL queries to run.
     */
    protected ContextNodeFields(List<String> queries, RDFServiceFactory rdfServiceFactory){   
        this.queries = queries;
        this.rdfServiceFactory = rdfServiceFactory;
    }        
    

    public StringBuffer getValues( Individual individual ){
        return executeQueryForValues( individual, queries );        
    }                
    
    @Override
    public void modifyDocument(Individual individual, SolrInputDocument doc, StringBuffer addUri) {        
        if( individual == null )
            return;
        
        log.debug( "processing context nodes for: " +  individual.getURI());
        
        /* get text from the context nodes and add the to ALLTEXT */        
        StringBuffer values = executeQueryForValues(individual, queries, doc);        
        
        SolrInputField field = doc.getField(VitroSearchTermNames.ALLTEXT);
        if( field == null ){
            doc.addField(VitroSearchTermNames.ALLTEXT, values);           
        }else{
            field.addValue(values, field.getBoost());
        }                                      
    }
    
    /**
     * this method gets values that will be added to ALLTEXT 
     * field of solr Document for each individual.
     * 
     * @param individual
     * @return StringBuffer with text values to add to ALLTEXT field of solr Document.
     */
    protected StringBuffer executeQueryForValues( Individual individual, Collection<String> queries){
        /* execute all the queries on the list and concat the values to add to all text */        
    	RDFService rdfService = rdfServiceFactory.getRDFService();
        StringBuffer allValues = new StringBuffer("");                

        for(String query : queries ){    
            StringBuffer valuesForQuery = new StringBuffer();
        	
            String subInUriQuery = query.replaceAll("\\?uri", "<" + individual.getURI() + "> ");
        	
            try{
            	
            	ResultSet results = RDFServiceUtils.sparqlSelectQuery(subInUriQuery, rdfService);               
            	while(results.hasNext()){                                                                               
                    valuesForQuery.append(getTextForRow( results.nextSolution() ) ) ; 
            	}
            	
            }catch(Throwable t){
                if( ! shutdown ) 
                    log.error(t,t);
            } 
            
            if(log.isDebugEnabled()){
                log.debug("query: '" + subInUriQuery+ "'");
                log.debug("text for query: '" + valuesForQuery.toString() + "'");
            }
            allValues.append(valuesForQuery);
        }
        
        rdfService.close();
        return allValues;        
    }
    
    /**
     * this method gets values that will be added to ALLTEXT 
     * field of solr Document for each individual and will also call a function to add each value to a separate field in solr
     * 
     * @param individual
     * @return StringBuffer with text values to add to ALLTEXT field of solr Document.
     */
    protected StringBuffer executeQueryForValues( Individual individual, Collection<String> queries, SolrInputDocument doc){
        /* execute all the queries on the list and concat the values to add to all text */        
    	RDFService rdfService = rdfServiceFactory.getRDFService();
        StringBuffer allValues = new StringBuffer("");                

        for(String query : queries ){    
            StringBuffer valuesForQuery = new StringBuffer();
        	
            String subInUriQuery = query.replaceAll("\\?uri", "<" + individual.getURI() + "> ");
        	
            try{
            	
            	ResultSet results = RDFServiceUtils.sparqlSelectQuery(subInUriQuery, rdfService);               
            	while(results.hasNext()){                    
            	    QuerySolution row = results.nextSolution();
                    valuesForQuery.append(getTextForRow( row ) ) ; 
                    //append each value from sparql queries to solr document as separate fields
                    getSolrFieldsForRow( row, doc );
            	}
            	
            }catch(Throwable t){
                if( ! shutdown ) 
                    log.error(t,t);
            } 
            
            if(log.isDebugEnabled()){
                log.debug("query: '" + subInUriQuery+ "'");
                log.debug("text for query: '" + valuesForQuery.toString() + "'");
            }
            allValues.append(valuesForQuery);
        }
        
        rdfService.close();
        return allValues;        
    }
    
    protected String getTextForRow( QuerySolution row){
        if( row == null )
            return "";

        StringBuffer text = new StringBuffer();
        Iterator<String> iter =  row.varNames() ;
        while( iter.hasNext()){
            String name = iter.next();
            RDFNode node = row.get( name );
            
            if( node != null ){
                text.append(" ").append( node.toString() );
                
            }else{
                log.debug(name + " is null");
            }                        
        }        
        return text.toString();
    }
    
    protected void getSolrFieldsForRow( QuerySolution row, SolrInputDocument doc){
        if( row == null )
            return;
        
        RDFNode dateTimeStartNode 	= null;
        RDFNode dateTimeEndNode 	= null;
        
        Iterator<String> iter =  row.varNames() ;
        while( iter.hasNext()){
            String name = iter.next();
            RDFNode node = row.get( name );
            if( node != null ){
                if ( name.equalsIgnoreCase("startYear") ) {
                    dateTimeStartNode = node;
                }
                if ( name.equalsIgnoreCase("endYear") ) {
                    dateTimeEndNode = node;
                }
                doc.addField("op_context_"+name, node.toString() );
                log.debug("Adding solr Field: " + "op_context_"+name + " | Value: " + node.toString() );
            }else{
                log.debug(name + " is null");
            }                        
        }
        
        //for projects
        if (dateTimeStartNode != null) {
            log.debug("start date found");
            
            if (dateTimeEndNode != null) {
                log.debug("end date found");
                String startYear = dateTimeStartNode.asLiteral().getString();
                String endYear = dateTimeEndNode.asLiteral().getString();
                
                int startYearInt = Integer.parseInt(startYear);
                int endYearInt = Integer.parseInt(endYear);
                
                //add a entry for each year the project was ongoing
                for(int i=startYearInt; i<=endYearInt; i++){
                    log.debug("Adding solr Field: op_context_projectActiveYear: " + Integer.toString(i));
                    doc.addField("op_context_projectActiveYear", Integer.toString(i) );
                }
            } 
        }
        
        
    }
    
    
    
    
    public void shutdown(){
        shutdown=true;  
    }
}
