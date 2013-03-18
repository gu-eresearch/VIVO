<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Individual profile page template for core:subjectarea individuals (extends individual.ftl in vivo)-->

<#-- Do not show the link for temporal visualization unless it's enabled -->
<#if temporalVisualizationEnabled>
    <#assign classSpecificExtension>
        <#include "individual-visualizationTemporalGraph.ftl">
    </#assign>
</#if>

<#include "individual.ftl">