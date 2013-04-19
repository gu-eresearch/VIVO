# Griffith University's VIVO customisations

This repository contains the customisations made by Griffith University as part of development of the Research Hub ( http://research-hub.griffith.edu.au ).
The Research Hub is based on VIVO/Vitro software version 1.5.1 ( see below section on VIVO ), and requires installation of VIVO/Vitro to create a working instance.

The Research Hub also uses a customised version of MOAI ( https://pypi.python.org/pypi/MOAI/2.0.0 ) to enable a OAI-PMH interface for data discovery.
Our MOAI customisations can be found here: https://github.com/gu-eresearch/VIVO_moai

The Griffith Research Hub was developed with funding from the Australian National Data Service (ANDS) and Griffith University.

## Documentation
The Research Hub does implement some customised user experiences in terms of imporved faceted search and enchanced editing templates, but has no major changes in regards to site administration and usage. 
We reccomend that you follow the VIVO documentation in the links below, for in-depth information on installation, upgrade, administration and ontology management, as well as the excellent and very active vivo-dev-all mailing list mentioned below.

### Developer / Administrator Documentation
For installation/upgrade documentation for VIVO/Vitro software version 1.5, please see the VIVO Installation and Upgrade Guides located on this page: https://wiki.duraspace.org/display/VIVO/Install+Guide.  

Below are some very basic steps for deploying a VIVO 1.5 instance with Griffith's customisations in a linux/unix environment:
(assumes working installations of Java, Tomcat 6, ant and git).  The only real difference from building a vanilla VIVO instance
from GitHub is that you are cloning Griffiths VIVO repository instead of the vanilla VIVO repository.

1. Create directory for vivo source:  <code>mkdir vivo </code>
2. Clone the Vitro core repository:  <code>git clone https://github.com/vivo-project/Vitro.git  Vitro</code>
3. Clone the Griffith modifications repository: <code>git clone https://github.com/gu-eresearch/VIVO.git vivo</code>
4. Enter the vivo directory: <code>cd vivo</code>
5. Create symlink to vitro core files: <code>ln -s ../Vitro vitro-core</code>
6. Modify your deploy.properties file to match your environment (see VIVO documentation for further details on this)
7. Test a build of your VIVO instance:  <code>ant test</code>
8. Compile and deploy VIVO instance: <code>ant all</code>
9. Start your tomcat server
10. Access your VIVO installation by pointing your browser to the designated VIVO url specified in deploy.properties


Planning for VIVO Install: https://wiki.duraspace.org/display/VIVO/Planning+a+VIVO+Installation  
Deplopying VIVO: https://wiki.duraspace.org/display/VIVO/Deploying+VIVO  
Specific 1.5 Install Guide: http://sourceforge.net/projects/vivo/files/Project%20Documentation/VIVO_Release_V1.5_Installation_Guide.pdf/download  
  
  


All VIVO/Vitro source code can be found on GitHub: https://github.com/vivo-project.

### User Documentation
The only functional change to the user experience of VIVO based on Griffiths modifications, is a different theme (display layout) including
a enhanced faceted search interface.  Otherwise, the experience of using and administering VIVO with Griffith's modifications are similar to that of a vanilla VIVO instance.
Therefore, for detailed documentation, please refer to all existing documentation created for VIVO and contained on the VIVO wiki: https://wiki.duraspace.org/display/VIVO/VIVO+Main+Page  

Site Administrator Guide: https://wiki.duraspace.org/display/VIVO/Site+Administrator+Guide  
Data Maintenance Issues: https://wiki.duraspace.org/display/VIVO/Data+Maintenance  
SPARQL Resources:  https://wiki.duraspace.org/display/VIVO/SPARQL+Resources  


## Contact
To contact the Research Hub project team, please jump to http://research-hub.griffith.edu.au/contact, fill out your enquiry, and we will get back to you as soon as possible.







# About VIVO

VIVO is an open source semantic web application originally developed and implemented at Cornell. 
When installed and populated with researcher interests, activities, and accomplishments, 
it enables the discovery of research and scholarship across disciplines at that institution and beyond. 

VIVO supports browsing and a search function which returns faceted results for rapid retrieval 
of desired information. Content in any local VIVO installation may be maintained manually, 
brought into VIVO in automated ways from local systems of record 
(such as HR, grants, course, and faculty activity databases), 
or from database providers (such as publication aggregators and funding agencies). 

## VIVO Resources

### Information center at VIVOWEB
http://vivoweb.org/

### SoureceForge Wiki:
http://sourceforge.net/apps/mediawiki/vivo/index.php?title=Main_Page


#### Mailing lists:
##### [vivo-dev-all](http://lists.sourceforge.net/lists/listinfo/vivo-dev-all) 
The best place to get your hands dirty in the VIVO Project. 
Developers and Implementers frequent this listserv to get the latest on feature design, 
development planning, and testing.

##### [vivo-ontology](http://lists.sourceforge.net/lists/listinfo/vivo-ontology)  
The VIVO ontology serves as the data model for the VIVO application as well as an 
independent ontology for representing researchers in the context of their 
experience, outputs, interests, accomplishments, and associated institutions. 
This list is a place where you can 
* raise modeling requirements, 
* share your domain expertise to improve or extend the ontology, 
* discuss the technical details of the design of the VIVO OWL ontology, 
* share general ontology topics and news.

##### [vivo-imp-issues](http://lists.sourceforge.net/lists/listinfo/vivo-imp-issues)  
Implementing VIVO for the first time? Upgrading to the latest version? 
This list brings implementers together to help identify and solve questions 
ranging from installation to best practices.

#### IRC
For instant access to VIVO developers visit the VIVO IRC Channel. 
VIVO is still a small project so this channel is frequented by developers and end users alike. 
All are welcome.

Network: irc.freenode.net  
Channel: #VIVO  
WebInterface: http://webchat.freenode.net/
