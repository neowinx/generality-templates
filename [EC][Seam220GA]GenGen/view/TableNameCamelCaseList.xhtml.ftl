<#import "*/gen-options.ftl" as opt>
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
<!DOCTYPE composition PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<ui:composition xmlns="http://www.w3.org/1999/xhtml"
	xmlns:s="http://jboss.com/products/seam/taglib"
	xmlns:ui="http://java.sun.com/jsf/facelets"
	xmlns:f="http://java.sun.com/jsf/core"
	xmlns:h="http://java.sun.com/jsf/html"
	xmlns:rich="http://richfaces.org/rich"
	xmlns:a="http://richfaces.org/a4j" template="/layout/template.xhtml">

	<ui:define name="body">
	
		<h1>${'#'}{messages.${entityName}_}</h1>
		

		<h:form id="${entityName?uncap_first}Search" styleClass="edit">

			<rich:simpleTogglePanel label="${'#'}{messages['msg_list_search_filter']}"
				switchType="client">
				<#list columns as column>
					<#if (!column.primaryKey)>
						<#if opt.sqlStringTypes?seq_contains(column.dataType)>
				<s:decorate template="/layout/display.xhtml">
					<ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
					<h:inputText id="${opt.mixedCase(column)}"
						value="${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}" />
				</s:decorate>
						<#elseif opt.sqlIntegerTypes?seq_contains(column.dataType)>
				<s:decorate template="/layout/display.xhtml">
					<ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
					<h:inputText id="${opt.mixedCase(column)}"
						value="${'#'}{${entityName?uncap_first}List.${entityName?uncap_first}.${opt.mixedCase(column)}}" />
				</s:decorate>
						</#if>
					</#if>
				</#list>

			</rich:simpleTogglePanel>

			<div class="actionButtons">
				<a:commandButton id="search" value="${'#'}{messages.msg_list_search_button}"
					action="/<@opt.printDirPerTable entityName />${entityName}List.xhtml">
					<f:param name="firstResult" value="0" />
				</a:commandButton>
				<s:button id="reset" value="${'#'}{messages['msg_list_search_reset_button']}"
					includePageParams="false" rendered="${'#'}{empty from}" />
				<s:button id="print" value="${'#'}{messages.msg_list_search_print_button}" rendered="${'#'}{empty from}"
					view="/<@opt.printDirPerTable entityName />${entityName}ListPdf.xhtml" />
				<s:button id="back" value="${'#'}{messages.msg_list_back}"
					view="/${'#'}{from}.xhtml"
					rendered="${'#'}{not empty from}"
					propagation="default" />
			</div>

		</h:form>

		<rich:panel>
			<f:facet name="header">${'#'}{messages['msg_list_search_results']}(${'#'}{empty ${entityName?uncap_first}List.resultList ? 0 : (${entityName?uncap_first}List.paginated ? ${entityName?uncap_first}List.resultCount : ${entityName?uncap_first}List.resultList.size)})</f:facet>
			<div class="results" id="tblActividadList"><h:outputText
				value="${'#'}{messages.msg_list_search_no_results}"
				rendered="${'#'}{empty ${entityName?uncap_first}List.obtenerLista${entityName}s()}" /> <rich:dataTable
				id="${entityName?uncap_first}List" var="_${entityName?uncap_first}"
				value="${'#'}{${entityName?uncap_first}List.resultList}"
				rendered="${'#'}{not empty ${entityName?uncap_first}List.resultList}">
				<#list tables as t>
					<#if (t.tableName == tableName)>
						<#assign thisTable = t />
						<#break />
					</#if>
				</#list>
				<@opt.iterate_columns_and_resolve_attributes thisTable ; column, attrname, attrOfattr, escapeOutputText>
					<#if column == opt.keyColumn>
						<#if !opt.useSequencesForIds>
				<h:column>
					<f:facet name="header">
						<ui:include src="/layout/sort.xhtml">
							<ui:param name="entityList" value="${'#'}{${entityName?uncap_first}List}" />
							<ui:param name="propertyLabel"
								value="${'#'}{messages.${entityName}_${opt.mixedCase(column)}}" />
							<ui:param name="propertyPath" value="${entityName?uncap_first}.${attrname}${attrOfattr}" />
						</ui:include>
					</f:facet>
					<h:outputText ${escapeOutputText}value="${'#'}{_${entityName?uncap_first}.${attrname}${attrOfattr}}" />
				</h:column>
						</#if>
					<#else>
						<#if (opt.imageUploadColumns?? && opt.imageUploadColumns?seq_contains(tableName) && opt.imageUploadColumns[opt.imageUploadColumns?seq_index_of(tableName) + 1]?seq_contains(column.columnName))>
				<rich:column style="text-align:center;">
					<f:facet name="header">
							<h:outputText value="${'#'}{messages.${entityName}_${opt.mixedCase(column)}}" />
					</f:facet>
					<s:graphicImage height="100px" width="100px" value="${'#'}{_${entityName?uncap_first}.${attrname}${attrOfattr}}" />
				</rich:column>
						<#else>
				<h:column>
					<f:facet name="header">
						<ui:include src="/layout/sort.xhtml">
							<ui:param name="entityList" value="${'#'}{${entityName?uncap_first}List}" />
							<ui:param name="propertyLabel"
								value="${'#'}{messages.${entityName}_${opt.mixedCase(column)}}" />
							<ui:param name="propertyPath" value="${entityName?uncap_first}.${attrname}${attrOfattr}" />
						</ui:include>
					</f:facet>
					<h:outputText ${escapeOutputText}value="${'#'}{_${entityName?uncap_first}.${attrname}${attrOfattr}}" />
				</h:column>
						</#if>
					</#if>
				</@opt.iterate_columns_and_resolve_attributes>

				<rich:column styleClass="action">
					<f:facet name="header">${'#'}{messages.msg_list_action_column}</f:facet>
					<s:link
						view="/${'#'}{empty from ? '<@opt.printDirPerTable entityName />${entityName}' : from}.xhtml"
						value="${'#'}{empty from ? '' : messages.msg_list_select}"
						propagation="${'#'}{empty from ? 'none' : 'default'}"
						id="${entityName?uncap_first}ViewId">
						<f:param name="${entityName?uncap_first}${opt.camelCase(opt.keyColumn)}"
							value="${'#'}{_${entityName?uncap_first}.${opt.mixedCase(opt.keyColumn)}}" />
					</s:link>
            		${'#'}{' '}
            		<s:link
						view="/<@opt.printDirPerTable entityName />${entityName}Edit.xhtml"
						value="${'#'}{messages.msg_edit}" propagation="none"
						id="${entityName?uncap_first}Edit" rendered="${'#'}{empty from<#if (opt.permissionData?size > 0)> and identity.hasRole('${tableName}_edit')</#if>}">
						<f:param name="${entityName?uncap_first}${opt.camelCase(opt.keyColumn)}"
							value="${'#'}{_${entityName?uncap_first}.${opt.mixedCase(opt.keyColumn)}}" />
					</s:link>
				</rich:column>
			</rich:dataTable></div>
		</rich:panel>

		<div class="tableControl"><s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
			rendered="${'#'}{${entityName?uncap_first}List.previousExists}"
			value="${'#'}{messages.left}${'#'}{messages.left} ${'#'}{messages['msg_list_first_page']}"
			id="firstPage">
			<f:param name="firstResult" value="0" />
		</s:link> <s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
			rendered="${'#'}{${entityName?uncap_first}List.previousExists}"
			value="${'#'}{messages.left} ${'#'}{messages.msg_list_previous_page}"
			id="previousPage">
			<f:param name="firstResult"
				value="${'#'}{${entityName?uncap_first}List.previousFirstResult}" />
		</s:link> <s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
			rendered="${'#'}{${entityName?uncap_first}List.nextExists}"
			value="${'#'}{messages.msg_list_next_page} ${'#'}{messages.right}"
			id="nextPage">
			<f:param name="firstResult"
				value="${'#'}{${entityName?uncap_first}List.nextFirstResult}" />
		</s:link> <s:link view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
			rendered="${'#'}{${entityName?uncap_first}List.nextExists}"
			value="${'#'}{messages.msg_list_last_page} ${'#'}{messages.right}${'#'}{messages.right}"
			id="lastPage">
			<f:param name="firstResult"
				value="${'#'}{${entityName?uncap_first}List.lastFirstResult}" />
		</s:link></div>

		<s:div styleClass="actionButtons" rendered="${'#'}{empty from}">
			<s:button view="/<@opt.printDirPerTable entityName />${entityName}Edit.xhtml" id="create"
				propagation="none"
		<#if (opt.permissionData?size > 0)>
				   rendered="${'#'}{identity.hasRole('${tableName}_create')}"
		</#if>
				value="${'#'}{<#if (opt.spanishFemaleGender(entityName))>messages.msg_create_female<#else>messages.msg_create_male</#if>}">
				<f:param name="${entityName?uncap_first}${opt.camelCase(opt.keyColumn)}" />
			</s:button>
		</s:div>

	</ui:define>

</ui:composition>