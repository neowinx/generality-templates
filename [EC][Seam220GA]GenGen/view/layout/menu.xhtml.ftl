<#import "*/gen-options.ftl" as opt>
<rich:toolBar
    xmlns="http://www.w3.org/1999/xhtml"
    xmlns:ui="http://java.sun.com/jsf/facelets"
    xmlns:h="http://java.sun.com/jsf/html"
    xmlns:f="http://java.sun.com/jsf/core"
    xmlns:s="http://jboss.com/products/seam/taglib"
    xmlns:rich="http://richfaces.org/rich"
    rendered="${'#'}{identity.loggedIn}">
    <rich:toolBarGroup>
        <h:outputText value="${'#'}{warProjectName}:"/>
        <s:link id="menuHomeId" view="/home.xhtml" value="${'#'}{messages.home_link_label}" propagation="none"/>
    </rich:toolBarGroup>
<#if opt.menuStructure??>
	<#list opt.menuStructure as menuItem>
		<#if menuItem?is_string>
			<#assign idx = opt.menuStructure?seq_index_of(menuItem) + 1 />
    <rich:dropDownMenu showDelay="250" hideDelay="0" submitMode="none">
        <f:facet name="label">${menuItem}</f:facet>
			<#list opt.menuStructure[idx] as sq>
				<#assign entityName = sq?replace("_", " ")?capitalize?replace(" ", "") />
	<rich:menuItem<#if (opt.permissionData?size > 0)> rendered="${'#'}{identity.hasRole('${sq}_list')}"</#if>>
    	<s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
           	value="${'#'}{messages.${entityName}_}"
           	id="${entityName}Id"
			includePageParams="false"
     		propagation="none"/>
     </rich:menuItem>
			</#list>
    </rich:dropDownMenu>
    	</#if>
	</#list>
<#else>
    <rich:dropDownMenu showDelay="250" hideDelay="0" submitMode="none">
        <f:facet name="label">Menu</f:facet>
	<#list tables as t>
  		<#assign entityName = t.tableName?replace("_", " ")?capitalize?replace(" ", "")>
	<rich:menuItem<#if (opt.permissionData?size > 0)> rendered="${'#'}{identity.hasRole('${tableName}_list')}"</#if>>
    	<s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
           	value="${'#'}{messages.${entityName}_}"
           	id="${entityName}Id"
			includePageParams="false"
     		propagation="none"/>
     </rich:menuItem>
	</#list>
    </rich:dropDownMenu>
</#if>
    <!-- @newMenuItem@ -->
    <rich:toolBarGroup location="right">
        <h:outputText id="menuWelcomeId" value="${'#'}{messages.menuWelcome}" rendered="${'#'}{identity.loggedIn}"/>
        <s:link id="menuLoginId" view="/login.xhtml" value="Login" rendered="${'#'}{not identity.loggedIn}" propagation="none"/>
        <s:link id="menuLogoutId" view="/home.xhtml" action="${'#'}{identity.logout}" value="${'#'}{messages.logout_link_label}" rendered="${'#'}{identity.loggedIn}" propagation="none"/>
		<h:form>
			<h:selectOneMenu value="${'#'}{localeSelector.localeString}">
				<f:selectItem itemLabel="${'#'}{messages.Language_en}" itemValue="en" />
				<f:selectItem itemLabel="${'#'}{messages.Language_es}" itemValue="es" />
			</h:selectOneMenu>
			<h:commandButton action="${'#'}{localeSelector.select}"
				value="${'#'}{messages['ChangeLanguage']}" />
		</h:form>
    </rich:toolBarGroup>
</rich:toolBar>