<#import "*/gen-options.ftl" as opt>
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
<?xml version="1.0" encoding="UTF-8"?>
<page xmlns="http://jboss.com/products/seam/pages"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://jboss.com/products/seam/pages http://jboss.com/products/seam/pages-2.2.xsd"
      login-required="true">
      
<#if (opt.permissionData?size > 0)>   <restrict>${'#'}{identity.hasRole('${tableName}_list')}</restrict></#if>

   <param name="firstResult" value="${'#'}{${entityName?uncap_first}List.firstResult}"/>
   <param name="sort" value="${'#'}{${entityName?uncap_first}List.orderColumn}"/>
   <param name="dir" value="${'#'}{${entityName?uncap_first}List.orderDirection}"/>
   <param name="logic" value="${'#'}{${entityName?uncap_first}List.restrictionLogicOperator}"/>

   <param name="from"/>
<#-- INSERTAMOS LOS PARAMETROS DE LISTA DE VALORES INVERSA PARA MANTENER EL FLUJO DE LLAMADAS -->
<#if (opt.lovTables?? && opt.lovTables?is_sequence)>
	<#list opt.lovTables as lovVal>
		<#if lovVal?is_string>
			<#list tables as t>
				<#if (t.tableName == lovVal)>
					<#assign lovMasterTable = t />
					<#break />
				</#if>
			</#list>
		<#elseif lovVal?is_sequence>
			<#list lovVal as lovColumn>
				<#list lovMasterTable.columns as col>
					<#if (lovColumn == col.columnName)>
						<#assign fk = opt.getFkFromTable(lovMasterTable,col) />
						<#if (fk?size > 0)>
							<#if (fk.pktableName == tableName)>
   <param name="${opt.mixedCaseStr(lovMasterTable.tableName)}From" />
   							</#if>
						</#if>
					</#if>
				</#list>
			</#list>
		</#if>
	</#list>
</#if>
<#list columns as column>
	<#if !column.primaryKey>
		<#if opt.sqlStringTypes?seq_contains(column.dataType)>
   <param name="${opt.mixedCase(column)}" value="${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}"/>
		<#elseif opt.sqlIntegerTypes?seq_contains(column.dataType)>
   <param name="${opt.mixedCase(column)}" value="${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}"/>
		</#if>
	</#if>
</#list>

</page>
