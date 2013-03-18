<%@ page import="java.util.*"%>
<%@ page import="java.io.*"%>
<%@ page import="java.net.*"%> 
<%@ page import="java.Util.*"%>

<%@ page import="edu.cornell.mannlib.vitro.webapp.beans.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.dao.*" %>
<%@ page import="org.apache.commons.lang.StringEscapeUtils" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page errorPage="/error.jsp"%>




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

        
        Syntax SYNTAX = Syntax.syntaxARQ;
            
        VitroRequest vreq = new VitroRequest(request);
        
        Model model = vreq.getJenaOntModel(); // getModel()
        if( model == null ){
            out.println("no model");
            return;
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
                            "SELECT DISTINCT ?uri (STR(?Name) as ?name) ?hasProfile \n"+
                            "WHERE\n"+
                            "{\n"+
                            "   {\n"+
                            "       ?uri a guhubext:GUPerson . \n"+
                            "       ?uri foaf:name ?Name . \n"+
                            "       ?uri rdf:type ?type .   \n"+
                            "       OPTIONAL { ?uri ?isprofiletype guhubext:ResearchHubPerson . }  \n"+
                            "       LET(?hasProfile := IF( bound(?isprofiletype), 1, 0) ) .  \n"+
                            "   }\n"+
                            "}\n"+
                            "#ORDER BY ?Name \n";
        
        
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
            RDFNode urinode = soln.get("uri");
            RDFNode namenode = soln.get("name");
            RDFNode profilenode = soln.get("hasProfile");

            JSONObject jsonObj = new JSONObject();   
            if (urinode != null) {
                jsonObj.put("uri", urinode.toString());                     
            }
            if (namenode != null) {
                jsonObj.put("name", namenode.toString());                       
            }
            if (profilenode != null) {
                jsonObj.put("hasprofile", profilenode.toString());                       
            }
            jsonArr.put(jsonObj);
        }
        
        //print JSON array to screen
        //out.println(jsonArr.toString());
        try {
            //print json array to file
            String filename = "/app/tomcat/rhapps/ROOT/admin/gupersons_array.json";
            File jsonOutFile = new File(filename);
            BufferedWriter bw_out = new BufferedWriter(new FileWriter(jsonOutFile));
            bw_out.write(jsonArr.toString());
            bw_out.close();
        }
        catch (IOException e)
        {
            e.printStackTrace();
        }
        
        

    
    




%>











    
    
    


 

