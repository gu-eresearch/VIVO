<%@ page language="java" contentType="text/html; charset=ISO-8859-1"
    pageEncoding="ISO-8859-1"%>
    
<%@taglib prefix="vitro" uri="/WEB-INF/tlds/VitroUtils.tld" %>
<%@page import="edu.cornell.mannlib.vitro.webapp.auth.requestedAction.usepages.UseMiscellaneousAdminPages" %>
<% request.setAttribute("requestedActions", new UseMiscellaneousAdminPages()); %>
<vitro:confirmAuthorization />

<%@page import="java.io.*"%>
<%@page import="java.util.*"%>

<% //response.setIntHeader("Refresh", 5); %>

    
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<META HTTP-EQUIV="REFRESH" CONTENT="5">
<META HTTP-EQUIV="PRAGMA" CONTENT="NO-CACHE">
<meta http-equiv="Content-Type" content="text/html; charset=ISO-8859-1">
<title>Application Log file</title>
<style>
	#logWrapper {
		width:90%;
		font-size: 11px;
		border: 1px dotted #ccc;
	}
</style>
</head>
<body>

<% 
	
	String nLines = request.getParameter("n");
	int maxLines = 100;
	if (nLines != null) {
		maxLines = Integer.parseInt(nLines);
	} 
	
	OutputStream outStream = response.getOutputStream();
	
	String src = "/app/tomcat/logs/researchhub.all.log";
	
  	BufferedReader reader = new BufferedReader(new FileReader(src));
    String[] lines = new String[maxLines];
    int lastNdx = 0;
    for (String line=reader.readLine(); line != null; line=reader.readLine()) {
        if (lastNdx == lines.length) {
            lastNdx = 0;
        }
        lines[lastNdx++] = line;
    }

    OutputStreamWriter writer = new OutputStreamWriter(outStream);
    writer.write("<pre>");
    for (int ndx=lastNdx; ndx != lastNdx-1; ndx++) {
        if (ndx == lines.length) {
            ndx = 0;
        }
        writer.write(lines[ndx]);
        writer.write("\n");
    }
    writer.write("</pre>");

    writer.flush();

%>

</body>
</html>