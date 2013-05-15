<#import "*/gen-options.ftl" as opt>
<?xml version="1.0" encoding="UTF-8"?>
<page xmlns="http://jboss.com/products/seam/pages"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://jboss.com/products/seam/pages http://jboss.com/products/seam/pages-2.2.xsd"
      login-required="true">

<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "") />
<#assign componentName = entityName?uncap_first />
<#assign listName = componentName + "List" />
   <param name="firstResult" value="${'#'}{${listName}.firstResult}"/>
   <param name="sort" value="${'#'}{${listName}.orderColumn}"/>
   <param name="dir" value="${'#'}{${listName}.orderDirection}"/>
   <param name="logic" value="${'#'}{${listName}.restrictionLogicOperator}"/>

   <param name="from"/>
<#list columns as column>
	<#if opt.sqlStringTypes?seq_contains(column.dataType)>
   <param name="${opt.mixedCase(column)}" value="${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}"/>
	</#if>
</#list>

</page>
