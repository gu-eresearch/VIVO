<#-- $This file is distributed under the terms of the license in /doc/license.txt$ -->

<#-- Template for property group menu on individual profile page -->

<#assign nameForOtherGroup = nameForOtherGroup!"other">

<#if (propertyGroups.all)??>
    <#assign groups = propertyGroups.all>
    
    <#if groups?has_content>
        <#if (groups?size > 1) || (groups?first).getName(nameForOtherGroup)?has_content> 
            <nav id="property-group-menu" role="navigation">
                <span itemscope itemtype="http://schema.org/WebPage">
                <ul role="list" >
                    <#list groups as group>
                        <#assign groupname = group.getName(nameForOtherGroup)>
                        <#if groupname?has_content>
                            <#-- capitalize will capitalize each word in the name; cap_first only the first. We may need a custom
                            function to capitalize all except function words. -->
                            <li role="listitem">
                                <a itemprop="significantLink" href="#${groupname}">${groupname?capitalize}</a>
                                <span class="separator-property-group-nav"></span>
                            </li>
                        </#if>
                    </#list>
                </ul>
                </span>
            </nav>
        </#if> 
    </#if>
</#if>

