<%@ page import="java.util.*"%>
<%@ page import="java.net.URLEncoder"%>
<%@ page import="java.Util.*"%>
<%@ page import="java.net.URLDecoder"%>
<%@ page import="edu.cornell.mannlib.vitro.webapp.beans.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.dao.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page errorPage="/error.jsp"%>


<%@page import="java.io.*"%>

<%@page import="com.hp.hpl.jena.query.DataSource"%>
<%@page import="com.hp.hpl.jena.query.DatasetFactory"%>
<%@page import="com.hp.hpl.jena.query.Query"%>
<%@page import="com.hp.hpl.jena.query.QueryExecution"%>
<%@page import="com.hp.hpl.jena.query.QueryExecutionFactory"%>
<%@page import="com.hp.hpl.jena.query.QueryFactory"%>
<%@page import="com.hp.hpl.jena.query.QuerySolution"%>
<%@page import="com.hp.hpl.jena.query.ResultSet"%>
<%@page import="com.hp.hpl.jena.query.ResultSetFormatter"%>
<%@page import="com.hp.hpl.jena.query.Syntax"%>
<%@page import="com.hp.hpl.jena.rdf.model.Literal"%>
<%@page import="com.hp.hpl.jena.rdf.model.Model"%>
<%@page import="com.hp.hpl.jena.rdf.model.ModelMaker"%>
<%@page import="com.hp.hpl.jena.rdf.model.Resource"%>
<%@page import="com.hp.hpl.jena.rdf.model.RDFNode"%>
<%@page import="com.hp.hpl.jena.rdf.model.Statement"%>
<%@page import="com.hp.hpl.jena.sparql.resultset.ResultSetFormat"%>

<%@page import="com.hp.hpl.jena.vocabulary.XSD"%>



<%@page import="edu.cornell.mannlib.vitro.webapp.beans.Ontology"%>
<%@page import="edu.cornell.mannlib.vitro.webapp.dao.OntologyDao"%>

<%@page import="org.json.JSONArray"%>
<%@page import="org.json.JSONException"%>
<%@page import="org.json.JSONObject"%>











<%!
public String getIndividualProperties(String uri) {
	String propString = "Get individual Properties for: " + uri + "<br/>";

	return propString;
}
%>

<%
if (request.getParameter("uri") != null) {
	
			

		String uriParameter = request.getParameter("uri");
		
		Syntax SYNTAX = Syntax.syntaxARQ;
			
		VitroRequest vreq = new VitroRequest(request);
		
		Model model = vreq.getJenaOntModel(); // getModel()
		if( model == null ){
			out.println("no model");
			return;
		}

		//Get Research Areas parameter
		String researchAreasFilter = "";
		if ( request.getParameterValues("resareas") != null) {
			String[] researchAreas = request.getParameterValues("resareas");
			researchAreasFilter = "FILTER ( "; //start filter
			for (int i = 0; i < researchAreas.length; ++i) {
				if (researchAreas[i].length() > 1) {  
					if (i > 0) {
						researchAreasFilter += " || ";
					}
					researchAreasFilter += " ?sa = <" + researchAreas[i] + "> ";	

				}
			}
			researchAreasFilter += " )\n"; //End filter statement

		}


		String queryPrefix = "PREFIX rdf:   <http://www.w3.org/1999/02/22-rdf-syntax-ns#>\n"+
							"PREFIX rdfs:  <http://www.w3.org/2000/01/rdf-schema#>\n"+
							"PREFIX xsd:   <http://www.w3.org/2001/XMLSchema#>\n"+
							"PREFIX owl:   <http://www.w3.org/2002/07/owl#>\n"+
							"PREFIX swrl:  <http://www.w3.org/2003/11/swrl#>\n"+
							"PREFIX swrlb: <http://www.w3.org/2003/11/swrlb#>\n"+
							"PREFIX vitro: <http://vitro.mannlib.cornell.edu/ns/vitro/0.7#>\n"+
							"PREFIX p.1: <http://purl.org/vocab/vann/>\n"+
							"PREFIX ands: <http://www.ands.org.au/ontologies/ns/0.1/VITRO-ANDS.owl#>\n"+
							"PREFIX p.2: <http://purl.org/asc/1297.0/>\n"+
							"PREFIX bibo: <http://purl.org/ontology/bibo/>\n"+
							"PREFIX dcterms: <http://purl.org/dc/terms/>\n"+
							"PREFIX event: <http://purl.org/NET/c4dm/event.owl#>\n"+
							"PREFIX foaf: <http://xmlns.com/foaf/0.1/>\n"+
							"PREFIX p.3: <http://purl.org/asc/1297.0/2008/for/>\n"+
							"PREFIX p.4: <http://purl.org/asc/1297.0/for/>\n"+
							"PREFIX geo: <http://aims.fao.org/aos/geopolitical.owl#>\n"+
							"PREFIX guhubext: <http://griffith.edu.au/ontology/hubextensions/>\n"+
							"PREFIX p.5: <http://www.w3.org/2003/06/sw-vocab-status/ns#>\n"+
							"PREFIX p.6: <http://www.w3.org/2006/vcard/ns#>\n"+
							"PREFIX pvs: <http://vivoweb.org/ontology/provenance-support#>\n"+
							"PREFIX ero: <http://purl.obolibrary.org/obo/>\n"+
							"PREFIX p.7: <http://purl.org/asc/1297.0/1998/rfcd/>\n"+
							"PREFIX scires: <http://vivoweb.org/ontology/scientific-research#>\n"+
							"PREFIX p.8: <http://purl.org/asc/1297.0/1998/seo/>\n"+
							"PREFIX p.9: <http://purl.org/asc/1297.0/2008/seo/>\n"+
							"PREFIX p.10: <http://purl.org/asc/1297.0/seo/>\n"+
							"PREFIX skos: <http://www.w3.org/2004/02/skos/core#>\n"+
							"PREFIX p.11: <http://www.w3.org/2006/time#>\n"+
							"PREFIX p.12: <http://purl.org/asc/1297.0/1993/toa/>\n"+
							"PREFIX p.13: <http://vitro.mannlib.cornell.edu/ns/vitro/public#>\n"+
							"PREFIX core: <http://vivoweb.org/ontology/core#>\n"+
							"PREFIX p.14: <http://vitro.mannlib.cornell.edu/ns/vitro/rdfIngestWorkflow#>\n";

		String  queryString = 
							"SELECT ?relatedAuthor (COUNT(?relatedAuthor) AS ?num)\n"+
							"WHERE\n"+
							"{\n"+
							"	{\n"+
							"		<"+uriParameter+"> core:authorInAuthorship ?authorship .\n"+
							"		?authorship core:linkedInformationResource ?infoRes .\n"+
							"		?infoRes core:hasSubjectArea ?sa .\n"+
							"		?infoRes core:informationResourceInAuthorship ?relatedAuthorship .\n"+
							"		?relatedAuthorship core:linkedAuthor ?relatedAuthor .\n"+
							"	    #?relatedAuthor rdfs:label ?label .\n"+
							"	    #Limit to specific research areas\n"+
							"       "+researchAreasFilter+"\n"+
							"	    FILTER (?relatedAuthor != <"+uriParameter+">)\n"+
							"  	}\n"+
							"}\n"+
							"GROUP BY ?relatedAuthor \n"+
							"ORDER BY DESC(?num)\n";
		
		
		queryString = queryPrefix + queryString;
		
		//out.println(queryString);
		Query query = QueryFactory.create( queryString, Syntax.syntaxARQ);
		
		// Execute the query and obtain results
		QueryExecution qe = QueryExecutionFactory.create(query, model);
		ResultSet results = qe.execSelect();
		//IndividualDao indDao = vreq.getWebappDaoFactory().getIndividualDao();
		
		JSONArray jsonArr = new JSONArray();     

		while(results.hasNext()){
		 	QuerySolution soln = results.nextSolution();
		 	RDFNode node = soln.get("relatedAuthor");
		 	RDFNode numnode = soln.get("num");


		 	if (node != null) {
		 		Resource res = node.asResource();
		 		JSONObject jsonObj = new JSONObject();   

				//Start populating the JSON object
				jsonObj.put("uri", res.toString());
		 		if (numnode != null) {
	 				jsonObj.put("num", numnode.asLiteral().getInt());		            	
	 			}         



	 			//Create lookup query for each individual
		 		String individualQuery = 
		 		"SELECT DISTINCT (STR(?label) AS ?name) ?email (STR(?afflabel) AS ?affname) \n"+
		 		"WHERE { \n"+
		 		"<"+res.toString()+"> rdfs:label ?label . \n"+
		 		"OPTIONAL {<"+res.toString()+"> core:email ?email . } \n"+
		 		"OPTIONAL {<"+res.toString()+"> guhubext:hasPrimaryAffiliationRole ?affiliationRole . ?affiliationRole core:roleIn ?org . ?org rdfs:label ?afflabel . } \n"+
		 		"} \n";


		 		//out.println(individualQuery);
		 		String individualQueryString = queryPrefix + individualQuery;
		 		Query indQuery = QueryFactory.create( individualQueryString, Syntax.syntaxARQ);
								
				// Execute the query and obtain results
				QueryExecution indqe = QueryExecutionFactory.create(indQuery, model);
				ResultSet indResults = indqe.execSelect();
				while(indResults.hasNext()){
					QuerySolution indsoln = indResults.nextSolution();


		 			RDFNode namenode = indsoln.get("name");
		 			if (namenode != null) {
		            	jsonObj.put("name", namenode.toString());
		        	}

		 			RDFNode emailnode = indsoln.get("email");
		 			if (emailnode != null) {
		 				jsonObj.put("email", emailnode.toString());
		 			}

		 			RDFNode orgnode = indsoln.get("affname");
		 			if (orgnode != null) {
		 				jsonObj.put("org", orgnode.toString());		            	
		 			}

		 			//Add the JSON object to the JSON array
		 			jsonArr.put(jsonObj);

				}

		 		/*
		 		// Code to use the jena api instead of SPARQL queries
		 		Resource res = node.asResource();
		 		out.println(getIndividualProperties( res.toString() ));
		 		Individual ind = indDao.getIndividualByURI(res.getURI());
		 		out.println(ind.getName());
		 		out.println(ind.getDataValue("http://vivoweb.org/ontology/core#email"));
						 		
				List<ObjectPropertyStatement> objectPropertyStatements = ind.getObjectPropertyStatements();
		        if (objectPropertyStatements != null) {
		            Iterator<ObjectPropertyStatement> objectPropertyStmtIter = objectPropertyStatements.iterator();
		            while (objectPropertyStmtIter.hasNext()) {
		                ObjectPropertyStatement objectPropertyStmt = objectPropertyStmtIter.next();
		                

		                if( "http://griffith.edu.au/ontology/hubextensions/hasPrimaryAffiliationRole".equals(objectPropertyStmt.getPropertyURI()) ){
		                    String t=null;
		                    t = objectPropertyStmt.getObject().getRdfsLabel();
		                    if (t != null) {
		                    	out.println(t);

		                	}
		                }
		            }
		        } 
				*/
		 		
		 		//Statement stmt = res.getProperty(new Property("http://www.w3.org/2000/01/rdf-schema#label"));
		 		//out.println(stmt.getString())
		 		
		 	}                 
		 	//out.println(binding.get("relatedAuthor")); 
		 	//out.println( getIndividualProperties( ( binding.get("relatedAuthor") ) );
		}
		//print JSON array
		out.println(jsonArr.toString());
	
    
} else {
	out.println("No uri parameter defined.");
}



%>











	
	
	


 

