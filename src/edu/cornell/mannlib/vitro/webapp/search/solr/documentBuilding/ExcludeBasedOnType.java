/* $This file is distributed under the terms of the license in /doc/license.txt$ */
package edu.cornell.mannlib.vitro.webapp.search.solr.documentBuilding;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

import edu.cornell.mannlib.vitro.webapp.beans.Individual;
import edu.cornell.mannlib.vitro.webapp.beans.VClass;

/**
 * Exclude individual from search index if
 * it is a member of any of the the types.
 * @author bdc34
 *
 */
public class ExcludeBasedOnType implements SearchIndexExcluder {

	private static final String SKIP_MSG = "skipping due to type.";
	
	/** The add, set and remove methods must keep this list sorted. */
    List<String> typeURIs;
    
    public ExcludeBasedOnType(String ... typeURIs) {    
        setExcludedTypes( typeURIs );
    }

    @Override
    public String checkForExclusion(Individual ind) { 
        if( ind == null ) 
        	return SKIP_MSG;

    	if( typeURIinExcludeList( ind.getVClass() ))
    		return SKIP_MSG;        	
    	
        List<VClass> vclasses = new ArrayList<VClass>();        
        vclasses.addAll( ind.getVClasses()!=null?ind.getVClasses():Collections.EMPTY_LIST );
        vclasses.addAll( ind.getVClasses(true)!=null?ind.getVClasses(true):Collections.EMPTY_LIST );
        
        
        //For Griffith we are doing this search limitation the other way round.
        //We want to only include items of certain classes, and exclude the rest.
        for( VClass vclz : vclasses){
        	if (vclz.getURI().equals("http://griffith.edu.au/ontology/hubextensions/ResearchHubPerson") ||
                vclz.getURI().equals("http://griffith.edu.au/ontology/hubextensions/GrantProject") ||
                vclz.getURI().equals("http://griffith.edu.au/ontology/hubextensions/ResearchHubProject") ||
                vclz.getURI().equals("http://griffith.edu.au/ontology/hubextensions/ResearchHubPublication") ||
                vclz.getURI().equals("http://griffith.edu.au/ontology/hubextensions/ResearchHubGroup") ||
                vclz.getURI().equals("http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#ResearchData") ||
                vclz.getURI().equals("http://vivoweb.org/ontology/core#Service")
        	) {
        	    return null; //index the individual
        	}
        	//if( typeURIinExcludeList( vclz ))
        	//	return SKIP_MSG;
        }     
        
        return SKIP_MSG;
    }
        
    protected boolean typeURIinExcludeList( VClass vclz){    
    	if( vclz != null && vclz.getURI() != null && !vclz.isAnonymous() ){
    		int pos = Collections.binarySearch(typeURIs, vclz.getURI());
    		return pos >= 0;    			        		        	
        }else{
        	return false;
        }    	
    }
    
    public void setExcludedTypes(String ... typeURIs){        
        setExcludedTypes(Arrays.asList(typeURIs));         
    }
    
    public void setExcludedTypes(List<String> typeURIs){
        synchronized(this){
            this.typeURIs =  new ArrayList<String>(typeURIs) ;
            Collections.sort( this.typeURIs );
        }
    }
    
    protected void addTypeToExclude(String typeURI){
        if( typeURI != null && !typeURI.isEmpty()){
            synchronized(this){
                typeURIs.add(typeURI);
                Collections.sort( this.typeURIs );
            }
        }
    }
    
    protected void removeTypeToExclude(String typeURI){        
        synchronized(this){
            typeURIs.remove(typeURI);            
        }
    }
}
