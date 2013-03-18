<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<meta charset="utf-8" />
<!-- Google Chrome Frame open source plug-in brings Google Chrome's open web technologies and speedy JavaScript engine to Internet Explorer-->
<meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">

<title>${title} | Griffith University</title>

<#-- <#include "stylesheets.ftl"> -->
<link rel="stylesheet" href="${urls.base}/css/vitro.min.css" />
<link rel="stylesheet" href="${urls.theme}/css/gu.css" />
<#--
<link rel="stylesheet" href="${urls.theme}/css/gu.min.css" />
<link rel="stylesheet" href="${urls.base}/css/vitro.css" />
<link rel="stylesheet" href="${urls.theme}/css/reset.css" />
<link rel="stylesheet" href="${urls.theme}/css/wilma.css" />
-->
<#include "stylesheets.ftl">
<#include "headScripts.ftl">
<#include "googleAnalytics.ftl">

<!--[if lt IE 7]>
<link rel="stylesheet" href="${urls.theme}/css/ie6.css" />
<![endif]-->

<!--[if IE 7]>
<link rel="stylesheet" href="${urls.theme}/css/ie7.css" />
<![endif]-->

<!--[if IE 8]>
<link rel="stylesheet" href="${urls.theme}/css/ie8.css" />
<![endif]-->

<#-- Inject head content specified in the controller. Currently this is used only to generate an rdf link on 
an individual profile page. -->
${headContent!}

<link rel="shortcut icon" type="image/x-icon" href="${urls.base}/favicon.ico">
