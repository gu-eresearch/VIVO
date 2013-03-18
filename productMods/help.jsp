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
        <title>Research Hub Help</title>
        
        ${ftl_head}
        
        <c:if test="${!empty scripts}"><jsp:include page="${scripts}"/></c:if>
        
    </head>
    
    <body ${requestScope.bodyAttr}>
            ${ftl_identity}
            
            ${ftl_menu}
                
                <div id="helpContent">
                    <h1>Research Hub Help</h1>
                    
                    <p>Are you a new user to the Research Hub? A good way to get started with the Hub is to read our <a href="/quick-start.jsp" title="Read The Quick Start Guide">Quick Start Guide</a>.  Otherwise, below is some more information and common questions.</p>
                    
                    <h2>Frequently Asked Questions <small><em>(click to read)</em></small></h2>
                    
                    <section id="FAQ">
                        <h3 id="FAQ1" class="faq_question">What is the Griffith Research Hub?</h3>
                        <article class="faq_answer">
                            <p>The Griffith Research Hub is a rich and informative guide to the University’s expertise in a comprehensive array of academic fields. The Research Hub contains pages profiling the activities of individual researchers. A profile page in the Research Hub automatically includes: publications, projects, research outputs and activities, contact details and more. </p>
                        </article>

                        <h3 id="FAQ2" class="faq_question">Where does the information in the Research Hub come from?</h3>
                        <article class="faq_answer">
                            <p>The Hub draws information automatically from Griffith University’s enterprise data sources including Office for Research’s Research Administration Database, My Research Publications, and the databases of the Office for Human Resources Management. </p>
                        </article>
                        
                        <h3 id="FAQ3" class="faq_question">Do all Griffith researchers have a profile page in the Hub?</h3>
                        <article class="faq_answer">
                            <p>Not all academics and researchers at Griffith have a profile page in the Research Hub. The researchers who have a profile page in the Hub have been assessed as "research active". There are a variety of measures used to calculate research activity. If you require a Hub profile, please contact your Dean or Head of School/Element. If you are an active researcher who is new to Griffith, you may not have a profile in the Hub because your data has not yet appeared in the Research Activity System (please see the specific Help topic about this).</p>
                        </article>
                    
                        <h3 id="FAQ4" class="faq_question">How can I change information in my Hub profile page?</h3>
                        <article class="faq_answer">
                            <p>The information presented on your profile page is obtained from different systems within the University and automatically includes, publications, projects, research outputs and activities, contact details and more. Some of this information is editable by you or someone you nominate to edit on your behalf. The source of the information determines whether you are able to change it from your profile page. Please download the <a target="_blank" href="${urls.base}/themes/gu/docs/researchhub-guide-edit.pdf">Hub Quick Start Guide</a> for instructions on how to edit information in your profile.</p>
                        </article>
                    
                    
                        <h3 id="FAQ5" class="faq_question">As a researcher who recently joined Griffith, how can I get a profile page in the Hub?</h3>
                        <article class="faq_answer">
                            <p>If you are a researcher who has recently joined Griffith University, you may not yet have a profile page in the Griffith Research Hub. The researchers who have a profile page in the Hub have been assessed as "research active". In order to assess your research activity, your data needs to appear in our Research Activity System. You can check your data in the MyPubs system (accessed via the Griffith portal). If the data is incomplete, there are a number of ways to get your data into the Research Activity System:</p>
                            <ul>
                                <li>1. Ask your Head of Element if there is a staff member who can enter the data on your behalf.</li>
                                <li>2. Enter the data yourself.</li>
                                <li>3. Approach the academic librarian assigned to your discipline.</li>
                                <li>4. Refer the matter to your Research Dean.</li>
                            </ul>
                        </article>
                    
                        <h3 id="FAQ6" class="faq_question">How can I find a supervisor to commence a PhD or other research degree at Griffith? </h3>
                        <article class="faq_answer">
                            <p>Griffith University is one of Australia's top ten research universities, receiving a rating of world standard or better in 45 fields of research in the Excellence in Research for Australia 2010 National Report. By this measure Griffith is in the top 10 for Australian universities and more than 90% of our academic staff are working in these fields.</p>
                            <p>We have a supportive research community and a vibrant research culture which provides an enriching environment for students. Many of our supervisors are at the forefront of scientific discovery, and go through a comprehensive accreditation process that supports the highest standards of supervision.</p>
                     
                            <p>Griffith offers a wide range of research degrees including: Doctor of Philosophy (PhD);
                            Professional Doctorates in Education, Visual Arts, and Music; Master of Philosophy; and
                            Research Masters degrees in Higher Education, Visual Arts, and Music.</p>
                             
                            <p>You can browse the Research Hub or search the Hub by subject keyword to find potential supervisors in your subject discipline. For further information on research degrees, or to enrol, go to: http://www.griffith.edu.au/higher-degrees-research</p>
                    
                        </article>
                    
                        <h3 id="FAQ7" class="faq_question">Who manages the Hub?</h3>
                        <article class="faq_answer">
                            <p>The Griffith Research Hub is managed by staff from eResearch Services, Scholarly Information and Research, Information Services at Griffith University. The Hub is governed by a Project Board which is chaired by Dr. Vicki Pattemore, Director, Office for Research.</p>
                        </article>
                    
                        <h3 id="FAQ8" class="faq_question">Who can I contact to provide feedback or ask for assistance?</h3>
                        <article class="faq_answer">
                            <p>The Research Hub team welcomes your comments and suggestions. You can provide feedback, or ask for assistance, by clicking the Contact Us tab.</p>
                        </article>
                    </section>
                </div>
                
            
            ${ftl_footer}

    </body>
    <script type="text/javascript">
        $(document).ready(function() {
           $('#helpMenuLink').addClass('selected'); 
           
            $('#helpContent').find('.faq_answer').hide();
           
            $('#helpContent').find('h3.faq_question').click(function() {
                $(this).next('.faq_answer').slideToggle();
                return false;
            })

         });
            
        
    </script>
</html>