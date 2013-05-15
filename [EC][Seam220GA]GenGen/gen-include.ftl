<#-- We recommend you do not touch this file unless you know what you are doing -->
<#assign sqlIntegerTypes = [-6,5,4,6]>
<#assign sqlLongTypes = [-5]>
<#assign sqlFloatTypes = [7]>
<#assign sqlNumberTypes = [-6,5,4,-5,6,7,8,3]>
<#assign sqlStringTypes = [1,12,-1,-15,-9]>
<#assign sqlDateTypes = [91]>
<#assign sqlTimestampTypes = [92,93]>
<#assign sqlBlobTypes = [2004,-4,-2,-3]>
<#assign sqlBooleanTypes = [-7]>
<#assign sqlBigDecimalTypes = [2]>
<#assign lastCol = columns?last>
<#list columns as column><#if column.primaryKey><#assign keyColumn = column><#break /></#if></#list>
<#function insertJavaType column>
  <#if sqlIntegerTypes?seq_contains(column.dataType)><#return "Integer">
  <#elseif sqlStringTypes?seq_contains(column.dataType)><#return "String">
  <#elseif sqlLongTypes?seq_contains(column.dataType)><#return "Long">
  <#elseif sqlFloatTypes?seq_contains(column.dataType)><#return "Float">
  <#elseif sqlBlobTypes?seq_contains(column.dataType)><#return "byte[]">
  <#elseif sqlDateTypes?seq_contains(column.dataType)><#return "Date">
  <#elseif sqlTimestampTypes?seq_contains(column.dataType)><#return "Date">
  <#elseif sqlBooleanTypes?seq_contains(column.dataType)><#return "Boolean">
  <#elseif sqlBigDecimalTypes?seq_contains(column.dataType)><#return "BigDecimal">
  <#else><#return "">
  </#if>
</#function>
<#macro newInstance column>
  <#if sqlIntegerTypes?seq_contains(column.dataType)>new Integer(1)<#t />
  <#elseif sqlStringTypes?seq_contains(column.dataType)>"AMDIN"<#t />
  <#elseif sqlLongTypes?seq_contains(column.dataType)>new Long(1)<#t />
  <#elseif sqlBlobTypes?seq_contains(column.dataType)>new byte[]<#t />
  <#elseif sqlDateTypes?seq_contains(column.dataType)>new Date()<#t />
  <#elseif sqlTimestampTypes?seq_contains(column.dataType)>new Date()<#t />
  <#elseif sqlBooleanTypes?seq_contains(column.dataType)>true<#t />
  <#elseif sqlBigDecimalTypes?seq_contains(column.dataType)>new BigDecimal(1)<#t />
  </#if>
</#macro>
<#function getFk columna>
	<#list foreignKeys as fk>
		<#if fk.fkcolumnName == columna.columnName>
		<#return fk>
		</#if>
	</#list>
	<#return {}>
</#function>
<#function spanishFemaleGender cadena>
	<#if (cadena?ends_with("a"))>
		<#return true />
	<#elseif (cadena?ends_with("dad") || cadena?ends_with("tad") || cadena?ends_with("tud"))>
		<#return true />
	<#elseif (cadena?ends_with("cion") || cadena?ends_with("sion") || cadena?ends_with("gion"))>
		<#return true />
	<#elseif (cadena?ends_with("ez") || cadena?ends_with("triz") || cadena?ends_with("umbre"))>
		<#return true />
	</#if>
	<#return false />
</#function>
<#function getFkFromTable table columna>
	<#list table.foreignKeys as fk>
		<#if fk.fkcolumnName == columna.columnName>
		<#return fk>
		</#if>
	</#list>
	<#return {}>
</#function>
<#function mixedCase column>
	<#return column.columnName?replace("_", " ")?capitalize?replace(" ", "")?uncap_first>
</#function>
<#function camelCase column>
	<#return column.columnName?replace("_", " ")?capitalize?replace(" ", "")>
</#function>
<#function mixedCaseStr str>
	<#return str?replace("_", " ")?capitalize?replace(" ", "")?uncap_first>
</#function>
<#function camelCaseStr str>
	<#return str?replace("_", " ")?capitalize?replace(" ", "")>
</#function>
<#function packageToPath pkg>
	<#return pkg?replace(".", "\\") />
</#function>
<#macro insertColumnAnnotation column>
<#if (sqlBlobTypes?seq_contains(column.dataType) && lobInBlobColumns)>	@Lob</#if><#t />
<#if sqlTimestampTypes?seq_contains(column.dataType)>	@Temporal(TemporalType.TIMESTAMP)<#t /><#elseif sqlDateTypes?seq_contains(column.dataType)>	@Temporal(TemporalType.DATE)<#t /></#if>
	@Column(name = "${column.columnName}")
</#macro>
<#macro printDirPerTable entityName><#if opt.dirPerTable>${opt.dirPerTablePrefix?replace("\\","/") + "/" + entityName?uncap_first + "/"}</#if></#macro>
<#macro printSelectOne attrname entityName column exportedEntity attrOfattr>
	<#if lovTables?? && lovTables?seq_contains(tableName) && lovTables[lovTables?seq_index_of(tableName) + 1]?seq_contains(column.columnName)>
	            <s:decorate id="${opt.mixedCase(column)}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
	                <h:panelGrid columns="2">
	                	<h:outputText id="${opt.mixedCase(column)}" value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}${attrOfattr}}" />
	                	<s:link view="/<@opt.printDirPerTable exportedEntity />${exportedEntity}List.xhtml">
	                		<f:param name="from" value="<@opt.printDirPerTable entityName />${entityName}Edit" />
	                		<#-- SI ESTA TABLA ES DETALLE DE ALGUN MAESTRO, INCLUIMOS EL F:PARAM DEL MAESTRO -->
	                		<@detail_master; masterTable, detailTable>
	                		<f:param name="${mixedCaseStr(detailTable.tableName)}From" value="<@opt.printDirPerTable camelCaseStr(masterTable.tableName) />${camelCaseStr(masterTable.tableName)}Edit" />
	                		</@detail_master>
	                		<img src="${'#'}{request.contextPath}/img/zoom-icon.png" />
	                	</s:link>
	                </h:panelGrid>
	            </s:decorate>
	<#else>
		<#assign factoryName = exportedEntity?uncap_first + "s" />
		<#if opt.useFactoriesForSelectItems>
	            <s:decorate id="${opt.mixedCase(column)}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
	                <h:selectOneMenu id="${opt.mixedCase(column)}"
	                		required ="${column.nullable?string("false", "true")}"
	                       disabled="false"
	                          value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}">
	                    <s:selectItems value="${'#'}{${factoryName}}" var="_${attrname}" label="${'#'}{_${attrname}${attrOfattr}}" />
	                    <s:convertEntity />
	                </h:selectOneMenu>
	            </s:decorate>
		<#else>
	            <s:decorate id="${opt.mixedCase(column)}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
	                <h:selectOneMenu id="${opt.mixedCase(column)}"
	                		required ="${column.nullable?string("false", "true")}"
	                       disabled="false"
	                          value="${'#'}{${entityName?uncap_first}Home.${opt.mixedCase(column)}}">
	                    <f:selectItems value="${'#'}{${factoryName + "SelectItems"}}" />
	                </h:selectOneMenu>
	            </s:decorate>
		</#if>
	</#if>
</#macro>
<#macro printDecorate attrname entityName column>
	<#if editorColumns?? && editorColumns?seq_contains(tableName) && editorColumns[editorColumns?seq_index_of(tableName) + 1]?seq_contains(column.columnName)>
		<#assign i = editorColumns?seq_index_of(tableName) + 1 />
		<#list editorColumns[i] as colName>
			<#if colName == column.columnName>
				<#if (useCodelabComponents?? && useCodelabComponents)>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	            	<ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
                    <codelab:editor id="${attrname}" value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}" />
	            </s:decorate>
				<#else>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	            	<ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
                    <rich:editor id="${attrname}" language="es" theme="advanced" value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}">
                        <f:param name="plugins" value="save,paste,style,advlink" />
                        <f:param name="theme_advanced_toolbar_location" value="top" />
                        <f:param name="theme_advanced_buttons1_add" value="cut,copy,paste,pasteword" />
                        <f:param name="theme_advanced_buttons2_add" value="styleprops" />
                        <!-- f:param name="theme_advanced_buttons3_add" value="mybutton,mybutton2,mybutton3,mybutton4,mybutton5" / -->
                        <f:param name="theme_advanced_toolbar_align" value="left" />
                        <!-- f:param name="content_css" value="${'#'}{facesContext.externalContext.requestContextPath}/stylesheet/tinyMceStyle.css" / -->
                        <!-- f:param name="setup" value="locoEd" / -->
                    </rich:editor>
	            </s:decorate>
	            </#if>
			</#if>
		</#list>
    <#elseif (imageUploadColumns?? && imageUploadColumns?seq_contains(tableName) && imageUploadColumns[imageUploadColumns?seq_index_of(tableName) + 1]?seq_contains(column.columnName))>
    	<#if (useCodelabComponents?? && useCodelabComponents)>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	            	<ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	                <codelab:uploadimage id="${attrname}" required ="${column.nullable?string("false", "true")}" disabled="false" value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}" />
	            </s:decorate>
	    <#else>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	            	<ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	            	<!-- This component requires manual implementation :) -->
	                <rich:upload id="logo" required ="${column.nullable?string("false", "true")}" />
	            </s:decorate>
	    </#if>
	<#elseif (sqlDateTypes?? && (sqlDateTypes?seq_contains(column.dataType) || sqlTimestampTypes?seq_contains(column.dataType)))>
		<#if (useCodelabComponents?? && useCodelabComponents)>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	                <codelab:calendar id="${attrname}"
                             required="${column.nullable?string("false", "true")}"
                                value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}" />
	            </s:decorate>
		<#else>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	                <rich:calendar id="${attrname}"
                             required="${column.nullable?string("false", "true")}"
                          datePattern="dd/MM/yyyy"
                			   locale="${'#'}{localeSelector.localeString}"
                                value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}" />
	            </s:decorate>
		</#if>
	<#elseif (sqlBooleanTypes?? && sqlBooleanTypes?seq_contains(column.dataType))>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	                <h:selectBooleanCheckbox id="${attrname}"
	                		required ="${column.nullable?string("false", "true")}"
	                       disabled="false"
	                          value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}" />
	            </s:decorate>
	<#elseif (staticValuesFields?? && staticValuesFields?seq_contains(tableName) && staticValuesFields[staticValuesFields?seq_index_of(tableName) + 1]?seq_contains(column.columnName))>
		<#assign svfTableIndex = -1 />
		<#list staticValuesFields as staticValuesField>
			<#assign svfTableIndex = svfTableIndex + 1 />
			<#if (staticValuesField?is_string)> 
				<#assign svfColumns = opt.staticValuesFields[svfTableIndex + 1] />
				<#if (svfColumns?seq_contains(column.columnName))>
					<#assign enumName = opt.camelCaseStr(staticValuesField) + opt.camelCaseStr(column.columnName) />
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${opt.mixedCase(column)}}</ui:define>
	                <h:selectOneMenu id="${attrname}"
	                		required ="${column.nullable?string("false", "true")}"
	                       disabled="false"
	                          value="${'#'}{${entityName?uncap_first}Home.instance.${opt.mixedCase(column)}}">
	                    <f:selectItems value="${'#'}{${enumName?uncap_first + "SelectItems"}}" />
	                </h:selectOneMenu>
	            </s:decorate>
					<#break />
				</#if>
			</#if>
		</#list>
	<#else>
	            <s:decorate id="${attrname}Field" template="/layout/edit.xhtml">
	                <ui:define name="label">${'#'}{messages.${entityName}_${attrname}}</ui:define>
	                <h:inputText id="${attrname}"
	                		required ="${column.nullable?string("false", "true")}"
	                       disabled="false" maxlength="${column.columnSize}"
	                          value="${'#'}{${entityName?uncap_first}Home.instance.${attrname}}">
	                    <a:support event="onblur" reRender="${opt.mixedCase(column)}Field" bypassUpdates="true" ajaxSingle="true"/>
	                </h:inputText>
	            </s:decorate>
	</#if>
</#macro>
<#macro iterate_columns_and_resolve_attributes table>
	<#assign attrNames = "" />
	<#list table.columns as column>
		<#assign attrOfattr = "" />
		<#assign attrname = opt.mixedCase(column) />
		<#if !column.primaryKey>
			<#assign fk = opt.getFkFromTable(table,column) />
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
		<#nested column attrname attrOfattr escapeOutputText />
	</#list>
</#macro>
<#-- RECORREMOS LOS DETALLES QUE TIENEN A tableName COMO MAESTRO -->
<#macro master_detail>
	<#if (masterDetailTables?? && masterDetailTables?seq_contains(tableName))>
		<#assign detailTables = masterDetailTables[masterDetailTables?seq_index_of(tableName) + 1] />
		<#list detailTables as det>
			<#list tables as ta>
				<#if (ta.tableName == det)>
					<#nested camelCaseStr(det) ta />
					<#break />
				</#if>
			</#list>
		</#list>
    </#if>
</#macro>
<#-- RECORREMOS LOS MAESTROS QUE TIENEN A tableName EN ALGUN DETALLE -->
<#macro detail_master>
	<#if (masterDetailTables?? && masterDetailTables?is_sequence)>
		<#assign masterTableName = "" />
		<#list masterDetailTables as mdt>
			<#if (mdt?is_string)>
				<#assign masterTableName = mdt />
			</#if>
			<#if (mdt?is_sequence && mdt?seq_contains(tableName))>
				<#list tables as detailTable>
					<#if (detailTable.tableName == tableName)>
						<#list tables as mt>
							<#if (mt.tableName == masterTableName)>
								<#assign masterTable = mt />
								<#break />
							</#if>
						</#list>
						<#nested masterTable detailTable />
						<#break />
					</#if>
				</#list>
			</#if>
		</#list>
    </#if>
</#macro>