/* $This file is distributed under the terms of the license in /doc/license.txt$ */

package edu.cornell.mannlib.vitro.webapp.controller.edit;

import java.io.IOException;
import java.io.StringReader;
import java.util.HashSet;
import java.util.Set;
import java.io.InputStream;
import java.util.List;
import java.util.Random;
import java.net.URLDecoder;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.apache.commons.httpclient.HttpStatus;
import org.apache.commons.logging.Log;
import org.apache.commons.logging.LogFactory;

import com.hp.hpl.jena.ontology.OntModel;
import com.hp.hpl.jena.rdf.model.Model;
import com.hp.hpl.jena.shared.Lock;

import com.hp.hpl.jena.datatypes.xsd.XSDDatatype;
import com.hp.hpl.jena.ontology.DatatypeProperty;
import com.hp.hpl.jena.ontology.Individual;
import com.hp.hpl.jena.ontology.OntClass;
import com.hp.hpl.jena.ontology.OntModelSpec;
import com.hp.hpl.jena.rdf.model.ModelFactory;
import com.hp.hpl.jena.rdf.model.Resource;
import com.hp.hpl.jena.rdf.model.ResourceFactory;


import edu.cornell.mannlib.vitro.webapp.auth.policy.PolicyHelper;
import edu.cornell.mannlib.vitro.webapp.auth.requestedAction.Actions;
import edu.cornell.mannlib.vitro.webapp.controller.VitroRequest;
import edu.cornell.mannlib.vitro.webapp.controller.ajax.VitroAjaxController;
import edu.cornell.mannlib.vitro.webapp.dao.jena.DependentResourceDeleteJena;
import edu.cornell.mannlib.vitro.webapp.dao.jena.event.EditEvent;
import edu.cornell.mannlib.vitro.webapp.edit.n3editing.processEdit.EditN3Utils;
import edu.cornell.mannlib.vitro.webapp.dao.WebappDaoFactory;

public class PrimitiveAdd extends VitroAjaxController {

    private static final long serialVersionUID = 1L;
    private String namespace;
	private String tboxNamespace;
	private String typeName;
	private String individualNameBase;
	private String propertyNameBase;

	/**
	 * No need to restrict authorization here. doRequest() will return an error
	 * if the user is not authorized.
	 */
	@Override
	protected Actions requiredActions(VitroRequest vreq) {
		return Actions.AUTHORIZED;
	}
    
    @Override
    protected void doRequest(VitroRequest vreq,
            HttpServletResponse response) throws ServletException, IOException {
        
 		WebappDaoFactory wadf = vreq.getWebappDaoFactory();
 		this.namespace = wadf.getDefaultNamespace();
 		this.individualNameBase = "ngen";
 		log.debug("namespace: " + this.namespace);
        
        //parse parameters
        String newObjectTypeRaw = vreq.getParameter("newObjectType");
		if ( newObjectTypeRaw == null ) {
        	doError(response,"newObjectType was not recognized.",500);
            return;
        }
        String newObjectType = URLDecoder.decode(newObjectTypeRaw, "UTF-8");
        String newObjectLabel = vreq.getParameter("newObjectLabel");
        
        String editorUri = EditN3Utils.getEditorUri(vreq);  
                 
        try {
        	String resultString = processChanges(wadf, editorUri, getWriteModel(vreq), newObjectType, newObjectLabel);
        	
        	response.getWriter().write(resultString);
        	
        } catch (Exception e) {
            doError(response,e.getMessage(),HttpStatus.SC_INTERNAL_SERVER_ERROR);
        }           
        
    }

	
	
	
	private String processChanges(WebappDaoFactory wadf, String editorUri, OntModel writeModel, String newObjectType, String newObjectLabel) throws Exception {
		String result = "fail";
		Lock lock = writeModel.getLock();
		URIGenerator uriGen = (wadf != null && writeModel != null) 
				? new RandomURIGenerator(wadf, writeModel)
		        : new SequentialURIGenerator();
		
		
		OntClass theOntClass = writeModel.getOntClass(newObjectType);
		log.debug("new object type:" + newObjectType);
		log.debug("theOntClass.getURI():" + theOntClass.getURI() );
		        
		try {
			Individual ind = null;
			String uri = uriGen.getNextURI();
			log.debug("Uri for new ind: " + uri);
			if (theOntClass != null) {
				log.debug("theontclass is not null");
				if(uri!=null) {
					log.debug("Uri for new ind: " + uri);
					ind = writeModel.createIndividual(uri,theOntClass);
					
					if (newObjectLabel != null) {
						log.debug("setting new object label to: " + newObjectLabel);
						ind.setLabel(newObjectLabel, "EN");
					}
					//ind.addRDFType( ResourceFactory.createResource(uri) );
					//log.debug("ind.getLabel: " + ind.getLabel() );
					log.debug("ind.getRDFType().getURI() 1 :  "+ ind.getRDFType().getURI() );
					ind.addOntClass(theOntClass);
					log.debug("ind.getRDFType().getURI() 2 : "+ ind.getRDFType().getURI() );
					if (ind != null) {
						result = uri;
					}
				}
        	}
		
			lock.enterCriticalSection(Lock.WRITE);
			writeModel.getBaseModel().notifyEvent(new EditEvent(editorUri, true));
			//writeModel.add(toBeAdded);
			//writeModel.remove(toBeRetracted);
		} catch (Throwable t) {
			throw new Exception("Error while modifying model \n" + t.getMessage());
		} finally {
			writeModel.getBaseModel().notifyEvent(new EditEvent(editorUri, false));
			lock.leaveCriticalSection();
		}
		return result;
	}
	

	
   
    private OntModel getWriteModel(HttpServletRequest request){
        HttpSession session = request.getSession(false);
        if( session == null || session.getAttribute("jenaOntModel") == null )
            return (OntModel)getServletContext().getAttribute("jenaOntModel");
        else
            return (OntModel)session.getAttribute("jenaOntModel");
    }

	/** Package access to allow for unit testing. */
	Model mergeModels(Set<Model> additions) {
		Model a = com.hp.hpl.jena.rdf.model.ModelFactory.createDefaultModel();
		for (Model m : additions) {
			a.add(m);
		}
		return a;
	}
	
	private interface URIGenerator {
		public String getNextURI();
	}
	
	private class RandomURIGenerator implements URIGenerator {
		
		private WebappDaoFactory wadf;
		private Model destination;
		private Random random = new Random(System.currentTimeMillis());
		
		public RandomURIGenerator(WebappDaoFactory webappDaoFactory, Model destination) {
			this.wadf = webappDaoFactory;
			this.destination = destination;
		}
		
		public String getNextURI() {
			boolean uriIsGood = false;
			boolean inDestination = false;
			String uri = null;
	        int attempts = 0;
			if(namespace!=null && !namespace.isEmpty()){
        		while( uriIsGood == false && attempts < 30 ){	
        			uri = namespace+"ngen"+random.nextInt( Math.min(Integer.MAX_VALUE,(int)Math.pow(2,attempts + 13)) );
        			String errMsg = wadf.checkURI(uri);
        			Resource res = ResourceFactory.createResource(uri);
        			inDestination = destination.contains(res, null);
        			if( errMsg != null && !inDestination)
        				uri = null;
        			else
        				uriIsGood = true;				
        			attempts++;
        		}
        	}
        	return uri;
		}
		
	}
	
	private class SequentialURIGenerator implements URIGenerator {
		private int index = 0;
		
		public String getNextURI() {
			index++;
			return namespace + "ngen" + Integer.toString(index); 
		}
	}

    Log log = LogFactory.getLog(PrimitiveAdd.class.getName());
}
