<#import "*/gen-options.ftl" as opt>
<!DOCTYPE composition PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "") />
<#assign componentName = entityName?uncap_first>
<#assign listName = componentName + "List">
<#assign pageName = entityName>
<#assign editPageName = entityName + "Edit">
<#assign listPageName = entityName + "List">
<p:document xmlns:p="http://jboss.com/products/seam/pdf"
    xmlns:s="http://jboss.com/products/seam/taglib"
    xmlns:ui="http://java.sun.com/jsf/facelets"
    xmlns:f="http://java.sun.com/jsf/core"
    xmlns:h="http://java.sun.com/jsf/html"
    xmlns:rich="http://richfaces.org/rich">

    <p:table widths="1 2" columns="2" widthPercentage="100" horizontalAlignment="left">
    	<p:cell borderWidth="0" verticalAlignment="middle" horizontalAlignment="center">
		    <p:html>
				<img src="${'#'}{facesContext.externalContext.context.getRealPath('/')}/img/seamlogo.png" alt="seamlogo.png"
					width="70" height="70" />
		    </p:html>
    	</p:cell>
    	<p:cell borderWidth="0" verticalAlignment="middle" horizontalAlignment="center">
			<p:paragraph><p:font name="HELVETICA" style="BOLD" size="18">${'#'}{messages['home_welcome_header']}</p:font></p:paragraph>
   		</p:cell>
   		<p:cell borderWidth="0" colspan="2" verticalAlignment="right" horizontalAlignment="center">
   			<p:paragraph><p:font name="HELVETICA" size="14">${'#'}{messages.${entityName}_}</p:font></p:paragraph>
   		</p:cell>
    </p:table>
    
    <p:table columns="2" widthPercentage="20" horizontalAlignment="left">
<#list columns as column>
<#if opt.sqlStringTypes?seq_contains(column.dataType)>
		<p:cell borderWidth="0" verticalAlignment="middle">
    		<p:paragraph><p:font name="HELVETICA" size="9" style="BOLD">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}:</p:font></p:paragraph>
    	</p:cell>
    	<p:cell borderWidth="0" verticalAlignment="middle">
    		<p:paragraph><p:font name="HELVETICA" size="9">${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}</p:font></p:paragraph>
    	</p:cell>
</#if>
</#list>
	</p:table>
	<p:paragraph spacingBefore="10" />
<#assign contador = 0 />
<#list columns as column>
	<#assign contador = contador + 1 />
</#list>
    <p:paragraph>
    	<p:font name="HELVETICA" size="9">
    	<p:table columns="${contador}" widthPercentage="100" headerRows="1">
<#list columns as column>
			<p:cell borderWidth="0" borderWidthBottom="1" horizontalAlignment="left"><p:paragraph>${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</p:paragraph></p:cell>
</#list>
			<ui:repeat value="${'#'}{${listName}.resultList}" var="_${componentName}">
			

<#assign attrNames = "" />
<#list columns as column>
  <#assign attrOfattr = "" />
  <#assign attrname = opt.mixedCase(column) />
  <#if !column.primaryKey>
	<#assign fk = opt.getFk(column) />
	<#if (fk?size > 0)>
		<#list tables as t>
			<#if t.tableName == fk.pktableName>
				<#if !opt.attributesFromColumnNames>
					<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
				</#if>
				<#assign itemGenerated = false />
				<#list t.columns as c>
					<#if opt.sqlStringTypes?seq_contains(c.dataType)>
						<#assign itemGenerated = true />
						<#assign attrOfattr = "." + opt.mixedCase(c) />
						<#break />
					</#if>
				</#list>
				<#if !itemGenerated>
				  <#list t.columns as c><#if c.primaryKey><#assign kc = column /><#break /></#if></#list>
				  <#assign attrOfattr = "." + opt.mixedCase(kc) />
				</#if>
				<#break />
			</#if>
		</#list>
	</#if>
  </#if>
  <#assign res = attrNames?matches(attrname)?size />
  <#assign attrNames = attrNames + " " + attrname />
  <#if res &gt; 0>
    <#assign attrname = attrname + res />
  </#if>
  <#assign escapeOutputText = "" />
	<#if opt.editorColumns?seq_contains(tableName)>
		<#assign i = opt.editorColumns?seq_index_of(tableName) + 1 />
		<#list opt.editorColumns[i] as colName>
			<#if colName == column.columnName>
		        <#assign escapeOutputText = "escape=\"false\" " />
			</#if>
		</#list>
	</#if>
				<p:cell borderWidth="0" horizontalAlignment="left">
					<p:paragraph>
						${'#'}{_${entityName?uncap_first}.${attrname}${attrOfattr}}
					</p:paragraph>
				</p:cell>
</#list>
			</ui:repeat>
	    </p:table>
	    </p:font>
	</p:paragraph>
</p:document>