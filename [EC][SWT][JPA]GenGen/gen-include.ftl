<#-- We recommend you do not touch this file unless you know what you are doing -->
<#assign sqlIntegerTypes = [-6,5,4,6] />
<#assign sqlLongTypes = [-5] />
<#assign sqlFloatTypes = [7] />
<#assign sqlNumberTypes = [-6,5,4,-5,6,7] />
<#assign sqlStringTypes = [1,12,-1,-15,-9] />
<#assign sqlDateTypes = [91] />
<#assign sqlTimestampTypes = [92,93] />
<#assign sqlBlobTypes = [2004,-4,-2] />
<#assign sqlBooleanTypes = [-7,16] />
<#assign sqlBigDecimalTypes = [2,3] />
<#assign sqlDoubleTypes = [8] />
<#assign lastCol = columns?last>
<#list columns as column><#if column.primaryKey><#assign keyColumn = column><#break /></#if></#list>
<#function insertJavaType column>
  <#if sqlIntegerTypes?seq_contains(column.dataType)><#return "Integer" />
  <#elseif sqlStringTypes?seq_contains(column.dataType)><#return "String" />
  <#elseif sqlLongTypes?seq_contains(column.dataType)><#return "Long" />
  <#elseif sqlFloatTypes?seq_contains(column.dataType)><#return "Float" />
  <#elseif sqlBlobTypes?seq_contains(column.dataType)><#return "byte[]" />
  <#elseif sqlDateTypes?seq_contains(column.dataType)><#return "Date" />
  <#elseif sqlTimestampTypes?seq_contains(column.dataType)><#return "Date" />
  <#elseif sqlBooleanTypes?seq_contains(column.dataType)><#return "Boolean" />
  <#elseif sqlBigDecimalTypes?seq_contains(column.dataType)><#return "BigDecimal" />
  <#elseif sqlDoubleTypes?seq_contains(column.dataType)><#return "Double" />
  <#else><#return "" />
  </#if>
</#function>
<#function getFk columna>
	<#list foreignKeys as fk>
		<#if fk.fkcolumnName == columna.columnName>
		<#return fk />
		</#if>
	</#list>
	<#return {} />
</#function>
<#function getFkFromTable table columna>
	<#list table.foreignKeys as fk>
		<#if fk.fkcolumnName == columna.columnName>
		<#return fk />
		</#if>
	</#list>
	<#return {} />
</#function>
<#function mixedCase column>
	<#return column.columnName?replace("_", " ")?capitalize?replace(" ", "")?uncap_first />
</#function>
<#function camelCase column>
	<#return column.columnName?replace("_", " ")?capitalize?replace(" ", "") />
</#function>
<#function mixedCaseStr str>
	<#return str?replace("_", " ")?capitalize?replace(" ", "")?uncap_first />
</#function>
<#function camelCaseStr str>
	<#return str?replace("_", " ")?capitalize?replace(" ", "") />
</#function>
<#function packageToPath pkg>
	<#return pkg?replace(".", "\\") />
</#function>
<#macro insertColumnAnnotation column>
<#if sqlTimestampTypes?seq_contains(column.dataType)>	@Temporal(TemporalType.TIMESTAMP)<#t /><#elseif sqlDateTypes?seq_contains(column.dataType)>	@Temporal(TemporalType.DATE)<#t /></#if>
	@Column(name = "${column.columnName}")
</#macro>