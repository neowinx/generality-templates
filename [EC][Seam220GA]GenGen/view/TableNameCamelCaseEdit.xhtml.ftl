<#import "*/gen-options.ftl" as opt>
<#assign entityName = tableName?replace("_", " ")?capitalize?replace(" ", "")>
<!DOCTYPE composition PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<ui:composition xmlns="http://www.w3.org/1999/xhtml"
    xmlns:s="http://jboss.com/products/seam/taglib"
    xmlns:ui="http://java.sun.com/jsf/facelets"
    xmlns:f="http://java.sun.com/jsf/core"
    xmlns:h="http://java.sun.com/jsf/html"
    xmlns:a="http://richfaces.org/a4j"
    xmlns:rich="http://richfaces.org/rich"
<#if (opt.useCodelabComponents?? && opt.useCodelabComponents)>    xmlns:codelab="http://codelab.com.py/seam-ui"</#if>    
    template="/layout/template.xhtml">

<ui:define name="body">
	<h1>${'#'}{messages.${entityName}_}</h1>

    <h:form id="${entityName?uncap_first}" styleClass="edit">

        <rich:panel>
            <f:facet name="header">${'#'}{${entityName?uncap_first}Home.managed ? messages.msg_edit  : <#if (opt.spanishFemaleGender(entityName))>messages.msg_add_female<#else>messages.msg_add_female</#if>} ${'#'}{messages.${entityName}_}</f:facet>

<#assign attrNames = "" />
<#list columns as column>
	<#assign notRenderDecorate = false />
	<#list opt.auditColumns as ac>
		<#if column.columnName == ac.columnName>
			<#assign notRenderDecorate = true />
			<#break />
		</#if>
	</#list>
	<#if !notRenderDecorate>
		<#assign itemGenerated = false />
		<#assign attrOfattr = "" />
		<#assign attrname = opt.mixedCase(column) />
		<#if !column.primaryKey>
			<#assign fk = opt.getFk(column) />
			<#if (fk?size > 0)>
				<#list tables as t>
					<#if t.tableName == fk.pktableName>
						<#assign exportedEntity = opt.camelCaseStr(fk.pktableName) />
						<#if !opt.attributesFromColumnNames>
							<#assign attrname = opt.mixedCaseStr(fk.pktableName) />
						</#if>
						<#list t.columns as c>
							<#if opt.sqlStringTypes?seq_contains(c.dataType)>
								<#assign itemGenerated = true />
								<#assign attrOfattr = "." + opt.mixedCase(c) />
								<@opt.printSelectOne attrname entityName column exportedEntity attrOfattr />
								<#break />
							</#if>
						</#list>
						<#if !itemGenerated>
							<#list t.columns as c><#if c.primaryKey><#assign kc = column /><#break /></#if></#list>
							<#assign itemGenerated = true />
							<#assign attrOfattr = "." + opt.mixedCase(kc) />
	            			<@opt.printSelectOne attrname entityName kc exportedEntity attrOfattr />
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
		<#if !itemGenerated>
			<#if column == opt.keyColumn>
				<#if !opt.useSequencesForIds>
	            <@opt.printDecorate attrname entityName column />
	            </#if>
	        <#else>
				<@opt.printDecorate attrname entityName column />
			</#if>
		</#if>
	</#if>
</#list>

        <div style="clear:both">
                <span class="required">*</span>
                ${'#'}{messages.msg_required_fields}
        </div>

        </rich:panel>

        <div class="actionButtons">

            <h:commandButton id="save"
                          value="${'#'}{messages.msg_save}"
                         action="${'#'}{${entityName?uncap_first}Home.persist}"
                       disabled="${'#'}{!${entityName?uncap_first}Home.wired}"                      
                       rendered="${'#'}{!${entityName?uncap_first}Home.managed}"/>

            <h:commandButton id="update"
                          value="${'#'}{messages.msg_update}"
                         action="${'#'}{${entityName?uncap_first}Home.update}"
                          onclick="return confirm('${'#'}{messages.msg_confirm_update}');"
                       rendered="${'#'}{${entityName?uncap_first}Home.managed}"/>

            <h:commandButton id="delete"
                          value="${'#'}{messages.msg_delete}"
                         action="${'#'}{${entityName?uncap_first}Home.remove}"
                        onclick="return confirm('${'#'}{messages.msg_confirm_delete}');"
                      immediate="true"
                       rendered="${'#'}{${entityName?uncap_first}Home.managed<#if (opt.permissionData?size > 0)> and identity.hasRole('${tableName}_delete')</#if>}"/>

            <s:button id="cancelEdit"
                   value="${'#'}{messages.msg_cancel}"
             propagation="end"
                    view="/<@opt.printDirPerTable entityName />${entityName}List.xhtml"
                rendered="${'#'}{${entityName?uncap_first}Home.managed}"/>

            <s:button id="cancelAdd"
                   value="${'#'}{messages.msg_cancel}"
             propagation="end"
                    view="/${'#'}{empty ${entityName?uncap_first}From ? '<@opt.printDirPerTable entityName />${entityName}List' : ${entityName?uncap_first}From}.xhtml"
                rendered="${'#'}{!${entityName?uncap_first}Home.managed}"/>

        </div>
    </h:form>

<#if (opt.masterDetailTables?? && opt.masterDetailTables?size > 0)>
	<rich:tabPanel switchType="ajax">
	<@opt.master_detail ; detailEntity, detailTable>
		<rich:tab label="${'#'}{messages.${opt.camelCaseStr(detailTable.tableName)}_}s">
			<div class="association" id="${detailEntity}Parent">
				<rich:dataTable var="_${detailEntity?uncap_first}" value="${'#'}{${entityName?uncap_first}Home.instance.${detailEntity?uncap_first}s}" 
					rendered="${'#'}{${entityName?uncap_first}Home.instance.${detailEntity?uncap_first}s != null}" rowClasses="rvgRowOne,rvgRowTwo">
				<@opt.iterate_columns_and_resolve_attributes detailTable ; detColumn, attrname, attrOfattr, escapeOutputText>
					<#if detColumn.primaryKey>
						<#if !opt.useSequencesForIds>
				<h:column>
					<f:facet name="header">
						<h:outputText value="${'#'}{messages.${detailEntity}_${opt.mixedCase(detColumn)}}" />
					</f:facet>
					<h:outputText ${escapeOutputText}value="${'#'}{_${detailEntity?uncap_first}.${attrname}${attrOfattr}}" />
				</h:column>
						</#if>
					<#else>
						<#if (opt.imageUploadColumns?? && opt.imageUploadColumns?seq_contains(tableName) && opt.imageUploadColumns[opt.imageUploadColumns?seq_index_of(tableName) + 1]?seq_contains(detColumn.columnName))>
				<rich:column style="text-align:center;">
					<f:facet name="header">
							<h:outputText value="${'#'}{messages.${detailEntity}_${opt.mixedCase(detColumn)}}" />
					</f:facet>
					<s:graphicImage height="100px" width="100px" value="${'#'}{_${detailEntity?uncap_first}.${attrname}${attrOfattr}}" />
				</rich:column>
						<#else>
				<h:column>
					<f:facet name="header">
						<h:outputText value="${'#'}{messages.${detailEntity}_${opt.mixedCase(detColumn)}}" />
					</f:facet>
					<h:outputText ${escapeOutputText}value="${'#'}{_${detailEntity?uncap_first}.${attrname}${attrOfattr}}" />
				</h:column>
						</#if>
					</#if>
				</@opt.iterate_columns_and_resolve_attributes>
				<h:column>
					<s:link value="${'#'}{messages.msg_delete}" action="${'#'}{${entityName?uncap_first}Home.instance.${detailEntity?uncap_first}s.remove(_${detailEntity?uncap_first})}" />
				</h:column>
				</rich:dataTable>
			</div>
			
				<#list detailTable.columns as detCol>
					<#if (detCol.primaryKey)>
						<#assign detailPrimaryColumn = detCol />
						<#break />
					</#if>
				</#list>
				<#if (detailPrimaryColumn??)>

        <div class="actionButtons">
            <s:button value="<#if (opt.spanishFemaleGender(detailEntity))>${'#'}{messages.msg_create_female}<#else>${'#'}{messages.msg_create_male}</#if> ${'#'}{${detailEntity}_}"
                    view="/<@opt.printDirPerTable detailEntity?uncap_first />${detailEntity}Edit.xhtml">
                 <f:param name="${detailEntity?uncap_first}From" value="<@opt.printDirPerTable entityName?uncap_first />${entityName}Edit"/>
            </s:button>
            <!-- s:button value="${'#'}{messages.msg_select}" view="/<@opt.printDirPerTable detailEntity?uncap_first />${detailEntity}List.xhtml">
                 <f:param name="from" value="<@opt.printDirPerTable entityName?uncap_first />${entityName}Edit"/>
            </s:button --> 
        </div>

				</#if>
		</rich:tab>
	</@opt.master_detail>
	</rich:tabPanel>
</#if>
        
</ui:define>

</ui:composition>
