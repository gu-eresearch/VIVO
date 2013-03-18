<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@taglib prefix="vitro" uri="/WEB-INF/tlds/VitroUtils.tld" %>
<%@page import="edu.cornell.mannlib.vitro.webapp.auth.requestedAction.usepages.UseMiscellaneousAdminPages" %>
<% request.setAttribute("requestedActions", new UseMiscellaneousAdminPages()); %>
<vitro:confirmAuthorization />

<%@page import="edu.cornell.mannlib.vitro.webapp.reasoner.SimpleReasoner"%>
<%@page import="edu.cornell.mannlib.vitro.webapp.dao.jena.pellet.PelletListener" %>
<%@page import="edu.cornell.mannlib.vitro.webapp.search.indexing.IndexBuilder" %>

<% 
  SimpleReasoner sr = SimpleReasoner.getSimpleReasonerFromServletContext(application);
  PelletListener pl = (PelletListener)application.getAttribute("pelletListener");
  IndexBuilder ib = (IndexBuilder)application.getAttribute(IndexBuilder.class.getName());
  
  long dt = 0;
  long tpi = 0;
  if (ib.isIndexing()) {
      dt = (System.currentTimeMillis() - ib.getStarttime());
      tpi = dt / ib.getCount();
  }
%>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Thread states</title>
<table>
  <tbody>
    <tr><td><h3>Simple Reasoner</h3></td></tr>
    <tr>
      <td>
        <table>
          <tbody>
            <tr>
              <td>SimpleReasoner</td>
              <td><%= sr.isRecomputing() %></td>
            </tr>
            <tr>
              <td>PelletReasoner</td>
              <td><%=  pl.isReasoning() %></td>
            </tr>
            <tr>
              <td>Indexer</td>
              <td><%= ib.isIndexing() %></td>
            </tr>
            <tr>
              <td>Indexed Count</td>
              <td><%= ib.getCount() %></td>
            </tr>
            <tr>
              <td>Start Time</td>
              <td><%= ib.getStarttime() %></td>
            </tr>
            <tr>
              <td>Average index time per individual</td>
              <td><%= tpi %> msec</td>
            </tr>        
          </tbody>
        </table>
  </tbody>
</table>


</head>
<body>

</body>
</html>