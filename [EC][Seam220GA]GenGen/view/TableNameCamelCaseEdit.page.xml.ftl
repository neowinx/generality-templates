<#import "*/gen-options.ftl" as opt>
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
<?xml version="1.0" encoding="UTF-8"?>
<page xmlns="http://jboss.com/products/seam/pages"
      xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
      xsi:schemaLocation="http://jboss.com/products/seam/pages http://jboss.com/products/seam/pages-2.2.xsd"
      no-conversation-view-id="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
      login-required="true">
      
<#if (opt.permissionData?size > 0)>   <restrict>${'#'}{identity.hasRole('${tableName}_create') or identity.hasRole('${tableName}_edit') or identity.hasRole('${tableName}_delete')}</restrict></#if>

   <begin-conversation flush-mode="MANUAL" join="true"/>

   <action execute="${'#'}{${entityName?uncap_first}Home.wire}"/>

   <param name="${entityName?uncap_first}From"/>
   <param name="${entityName?uncap_first}${opt.camelCase(opt.keyColumn)}" value="${'#'}{${entityName?uncap_first}Home.${entityName?uncap_first}${opt.camelCase(opt.keyColumn)}}"/>
<#-- INSERTAMOS LOS PARAMETROS DE LISTA DE VALORES -->
<#if (opt.lovTables?? && opt.lovTables?is_sequence && opt.lovTables?seq_contains(tableName))>
	<#if (opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1]?is_sequence)>
		<#list opt.lovTables[opt.lovTables?seq_index_of(tableName) + 1] as lovColumn>
			<#list columns as column>
				<#if (lovColumn == column.columnName)>
					<#assign fk = opt.getFk(column) />
					<#if (fk?size > 0)>
						<#assign importedEntityName = opt.camelCaseStr(fk.pktableName) />
						<#assign importedEntityKeyColumn = opt.camelCaseStr(fk.pkcolumnName) />
   <param name="${importedEntityName?uncap_first}${importedEntityKeyColumn}" value="${'#'}{${importedEntityName?uncap_first}Home.${importedEntityName?uncap_first}${importedEntityKeyColumn}}"/>
					</#if>
   				</#if>
   			</#list>
   		</#list>
	</#if>
</#if>
   <navigation from-action="${'#'}{${entityName?uncap_first}Home.persist}">
      <rule if-outcome="persisted" if="${'#'}{empty ${entityName?uncap_first}From}">
         <end-conversation/>
         <redirect view-id="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"/>
      </rule>
      <rule if-outcome="persisted" if="${'#'}{not empty ${entityName?uncap_first}From}">
         <end-conversation/>
         <redirect view-id="/${'#'}{${entityName?uncap_first}From}.xhtml"/>
      </rule>
   </navigation>

   <navigation from-action="${'#'}{${entityName?uncap_first}Home.update}">
      <rule if-outcome="updated" if="${'#'}{empty ${entityName?uncap_first}From}">
         <end-conversation/>
         <redirect view-id="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"/>
      </rule>
      <rule if-outcome="updated" if="${'#'}{not empty ${entityName?uncap_first}From}">
         <end-conversation/>
         <redirect view-id="/${'#'}{${entityName?uncap_first}From}.xhtml"/>
      </rule>
   </navigation>

   <navigation from-action="${'#'}{${entityName?uncap_first}Home.remove}">
      <rule if-outcome="removed">
         <end-conversation/>
         <redirect view-id="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"/>
      </rule>
   </navigation>

</page>