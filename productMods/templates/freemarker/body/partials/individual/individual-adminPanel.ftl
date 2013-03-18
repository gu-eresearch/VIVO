<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for admin panel on individual profile page -->

<#import "lib-form.ftl" as form>

<#if individual.showAdminPanel>
    <section id="admin" style="clear:both;">
        <h3>Admin Panel</h3>
        <table class="adminTable" border="0">
            <tr>
                <th width="200px" style="text-align:left;">Edit Individual in Admin Interface</th>
                <td><a href="${individual.controlPanelUrl()}">Edit</a></td>
            </tr>
            <tr>
                <#if verbosePropertySwitch??>
                    <#assign anchorId = "verbosePropertySwitch">
                    <#assign currentValue = verbosePropertySwitch.currentValue?string("on", "off")>
                    <#assign newValue = verbosePropertySwitch.currentValue?string("off", "on")>
                    <th>Verbose property display is <b>${currentValue}</b></th>
                    <td><a id="${anchorId}" class="verbose-toggle small" href="${verbosePropertySwitch.url}#${anchorId}">Turn ${newValue}</a></td>
                </#if> 

            </tr>
            <tr>
                <th>Resource URI</th>
                <td><a href="${individual.uri}" target="_blank">${individual.uri}</a></td>
            </tr>
            <tr>
                <th>SPARQL Query for individual</th>
                <td>
                    <form method="get" action="../admin/sparqlquery">
                        <input type="hidden" value="PREFIX rdf: &lt;http://www.w3.org/1999/02/22-rdf-syntax-ns#&gt;
                                    PREFIX rdfs: &lt;http://www.w3.org/2000/01/rdf-schema#&gt;
                                    SELECT   ?g ?pred  ?predLabel ?obj ?objLabel
                                    WHERE 
                                    {
                                     { GRAPH ?g { &lt;${individual.uri}&gt; ?pred ?obj} } 
                                     OPTIONAL { GRAPH ?h { ?obj rdfs:label ?objLabel } }
                                     OPTIONAL { GRAPH ?i { ?pred rdfs:label ?predLabel } }
                                    }
                                    limit 10000" name="query">
                        <input type="hidden" value="RS_TEXT" name="resultFormat">
                        <input type="submit" value="See all RDF results where this resource is a subject" class="form-button">
                    </form>
                </td>
            </tr>
             <!--
             <tr>
                <th>DESCRIBE individual in N3 format</th>
                <td>
                    <form method="get" action="../admin/sparqlquery">
                        <input type="hidden" value="DESCRIBE &lt;${individual.uri}&gt;" name="query">
                        <input type="hidden" value="N3" name="resultFormat">
                        <input type="submit" value="Describe Individual in N3 format" class="form-button">
                    </form>
                </td>
            </tr>
            -->
        </table>


    </section>
</#if>





