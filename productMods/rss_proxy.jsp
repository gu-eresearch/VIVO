<%@ page
    import="java.io.*,
            java.net.*"
    contentType="text/xml; charset=UTF-8"
%><%
        StringBuffer sbf = new StringBuffer();
        //Access the page
        try {
                URL url = new URL("http://poc-app.griffith.edu.au/news/topics/research/feed/");
                BufferedReader in = new BufferedReader(new InputStreamReader(url.openStream()));
                String inputLine;
                while ( (inputLine = in.readLine()) != null) sbf.append(inputLine);
                in.close();
                
                String filename = "/app/tomcat/rhapps/ROOT/rss_cache.xml";
                
                
                File xmlOutFile = new File(filename);
                //out.println(xmlOutFile.getCanonicalPath());
                
                try {
                    BufferedWriter bw_out = new BufferedWriter(new FileWriter(xmlOutFile));
                    String outText = sbf.toString();
                    bw_out.write(outText);
                    bw_out.close();
                }
                catch (IOException e)
                {
                    e.printStackTrace();
                }
                
        } catch (MalformedURLException e) {
        } catch (IOException e) {
        }
%>

<%= sbf.toString() %>