<%--
Copyright (c) 2011, Cornell University
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

    * Redistributions of source code must retain the above copyright notice,
      this list of conditions and the following disclaimer.
    * Redistributions in binary form must reproduce the above copyright notice,
      this list of conditions and the following disclaimer in the documentation
      and/or other materials provided with the distribution.
    * Neither the name of Cornell University nor the names of its contributors
      may be used to endorse or promote products derived from this software
      without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
--%>

<%@ page import="edu.cornell.mannlib.vedit.beans.LoginStatusBean" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.web.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.beans.*" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.VitroRequest" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.dao.WebappDaoFactory" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.dao.IndividualDao" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page errorPage="/error.jsp"%>
<%@ page contentType="text/html; charset=UTF-8"%>
<%@ page import="edu.cornell.mannlib.vitro.webapp.filters.VitroRequestPrep" %>
<%@ page import="edu.cornell.mannlib.vitro.webapp.controller.freemarker.FreemarkerHttpServlet" %>

<%  /***********************************************
         Display a single Page  in the most basic fashion.
         The html <HEAD> is generated followed by the banners and menu.
         After that the result of the jsp in the attribute bodyJsp is inserted.
         Finally comes the footer.
         
         request.attributes:                    
            "bodyJsp" - jsp of the body of this page.
            "title" - title of page
            "css" - optional additional css for page
            "scripts" - optional name of file containing <script> elements to be included in the page
            "bodyAttr" - optional attributes for the <body> tag, e.g. 'onload': use leading space
            "portalBean" - PortalBean object for request.
            
          Consider sticking < % = MiscWebUtils.getReqInfo(request) % > in the html output
          for debugging info.
                 
         bdc34 2006-02-03 created
        **********************************************/
        /*
        String e = "";
        if (request.getAttribute("bodyJsp") == null){
            e+="basicPage.jsp expects that request parameter 'bodyJsp' be set to the jsp to display as the page body.\n";
        }
        if (request.getAttribute("title") == null){
            e+="basicPage.jsp expects that request parameter 'title' be set to the title to use for page.\n";
        }
        if (request.getAttribute("css") == null){
            e+="basicPage.jsp expects that request parameter 'css' be set to css to include in page.\n";
        }
        if( request.getAttribute("portalBean") == null){
            e+="basicPage.jsp expects that request attribute 'portalBean' be set.\n";
        }
        if( request.getAttribute("appBean") == null){
            e+="basicPage.jsp expects that request attribute 'appBean' be set.\n";
        }
        if( e.length() > 0 ){
            throw new JspException(e);
        }
        */
%>


<% /* Prepare Freemarker components to allow .ftl templates to be included from jsp */
    FreemarkerHttpServlet.getFreemarkerComponentsForJsp(request);
%>


<%
    /*
    //Individual htmlInd = new Individual("http://research-hub-dev.griffith.edu.au/individual/helpHtml");
    VitroRequest req = new VitroRequest(request);
    LoginStatusBean loginBean = LoginStatusBean.getBean(req);
    WebappDaoFactory myWebappDaoFactory = req.getFullWebappDaoFactory().getUserAwareDaoFactory(loginBean.getUserURI());
    IndividualDao individualDao = myWebappDaoFactory.getIndividualDao();
    //PropertyInstanceDao propertyInstanceDao = myWebappDaoFactory.getPropertyInstanceDao();
    
    Individual ind = individualDao.getIndividualByURI("http://"+request.getServerName()+"/individual/helpHtml"); 
    
    String htmlContent = ind.getDataValue("http://vivoweb.org/ontology/core#description");
    
    */

%>


<!DOCTYPE html>
<html lang="en">
    <head>
        <title>Research Hub Quick Start Guide</title>
        
        ${ftl_head}
        
        <c:if test="${!empty scripts}"><jsp:include page="${scripts}"/></c:if>
        
    </head>
    
    <body ${requestScope.bodyAttr}>
            ${ftl_identity}
            
            ${ftl_menu}
                
                <div id="quickStartContent">
                    <span style="font-size:12px;font-style:italic;float:right;margin-top:10px;"><a href="javascript:window.print()" title="Print This Page">Click Here To Print This Page</a></span>
                    <h1>Quick Start Guide</h1>
                    
                    <img src="themes/gu/images/hub-user-pic.jpg" align="right" class="big-pic" width="375" style="margin-left:25px;margin-top:-6px;">
                    <p>The Griffith Research Hub is a rich and informative guide to the University’s expertise in a comprehensive array of academic fields. The Research Hub contains pages profiling the activities of individual researchers. This document will assist you to maintain the user editable portions of your profile page, including your biographical statement, research area keywords, important links, and background information. </p>
                    <p>A profile page in the Research Hub automatically includes: publications, projects, research outputs and activities, contact details and more. The information presented on your profile page is obtained from different systems within the University. The source of the information determines whether you are able to change it from your profile page. Icons appear beside pieces of information in your profile that you are able to edit, add to, delete or hide from public display.</p>
                    
                    <h3>Logging in to your profile</h3>
                    <p>To view and change the editable information on your profile page, first login to the Research Hub. From the home page, on the top right beneath the ‘contact us’ tab, click the ‘login’ button.</p>
                    <p style="text-align:center;margin:18px;0px"><img src="themes/gu/images/hub-login-pic.jpg" class="big-pic"></p>
                    <p>If you are already logged into the Griffith Portal, the Hub will automatically log you in after you click the ‘login’ button. If not, you will be prompted to sign in to the Portal. After you have logged in, you will automatically be taken to your profile page.</p>                  
                    
                    <h3>Understanding the edit view</h3>
                    <p>On your profile page, these icons appear beside information that you can change:
                        <ul id="icons">
                            <li><img src="images/individual/editIcon.gif"><strong>Edit</strong><br/> Allows you to change information</li>
                            <li><img src="images/individual/addIcon.gif"><strong>Add</strong><br/> Allows you to provide additional information.</li>
                            <li><img src="images/individual/deleteIcon.gif"><strong>Delete</strong><br/> Allows you to delete information.</li>
                            <li><img src="themes/gu/images/eye.png"><strong>Display</strong><br/> Allows you to manage the display of information.</li>
                        </ul>
                    </p>
                    
                    <h3>Edit existing information</h3>
                    <p>Use the edit button on your profile page to change or update an information element in your profile.<br/>
                            <ol>
                                <li><p>Click the edit icon (<img src="images/individual/editIcon.gif" style="vertical-align:middle;">) beside the information you wish to change.</p></li>
                                <li><p>Change the information.</p></li>
                                <li><p>Click the <em>save change</em> button.</p></li>
                            </ol>
                    </p>

                    <h3>Add new information</h3>
                    <p>Use the add button on your profile page to provide additional information.<br/>
                            <ol>
                                <li><p>Click the add icon (<img src="images/individual/addIcon.gif" style="vertical-align:middle;">) beside information you wish to edit.</p></li>
                                <li><p>Provide the additional information.</p></li>
                                <li><p>Follow the prompts to save.</p></li>
                            </ol>
                    </p>
                    
                    <h3>Delete information</h3>
                    <p>Use the delete button on your profile page to remove information from your profile.<br/>
                            <ol>
                                <li><p>Click the delete icon (<img src="images/individual/deleteIcon.gif" style="vertical-align:middle;">) beside the information you wish to remove.</p></li>
                                <li><p>Click the <em>delete</em> button to confirm.</p></li>
                            </ol>
                    </p>
                    
                    <h3>Change the display of information</h3>
                    <p>Use the display button to change the display of information on your profile page. This button also allows you to turn of the display of items that you are not able to edit.<br/>
                            <ol>
                                <li><p>Click the display icon (<img src="themes/gu/images/eye.png" style="vertical-align:middle;">) beside the information.</p></li>
                                <li><p>Follow the prompts.</p></li>
                            </ol>
                    </p>
                    
                    <div id="note">
                        <h3>Please Note</h3>
                        <p>
                            <ul>
                                <li><p>Information you delete from your profile may not be restored. Similarly if you change information on your profile using the edit button and then save the changes, the earlier version of the information may not be restored.</p></li>
                                <li><p>After you have completed and saved your changes, click the ‘logout’ button to sign off.</p></li>
                                <li><p>Visit the <a href="/about" title="About the Research Hub."style="color:#c02424;">About</a> and <a href="/help" title="Research Hub Help and FAQ." style="color:#c02424;">Help</a> pages to find more information and assistance. If you require additional information please use the ‘contact us’ tab on the Research Hub home page.</p></li>
                            </ul>
                        </p>
                    </div>
                    
                    <h3>Updating other information</h3>
                    <p>Information that does not have an edit, add or delete icon beside it may not be changed from your profile page. If you require changes to this information, please refer to the ‘help’ tab to obtain details of who to contact regarding the change.</p>
                    
                    <h3>Nominate someone else to maintain your profile </h3>
                    <p>You can nominate someone to maintain your Hub profile page on your behalf. Use the ‘contact us’ tab to request access for your nominee.</p>

                    <a href="/" title="Return to the Research Hub Home Page" class="blue button" style="margin:15px 0px;">Start Using The Hub!</a>
                    
                </div>
                
            
            ${ftl_footer}

    </body>
    <script type="text/javascript">
        $(document).ready(function() {
            function printpage()
              {
              window.print()
              }

         });
            
        
    </script>
</html>