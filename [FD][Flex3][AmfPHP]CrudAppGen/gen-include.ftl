<#-- LEAVE THESE SETTINGS ALONE!!! DONT CHANGE ANYTHING FROM HERE -->
<#assign sqlNumberTypes = [-7,-6,5,4,-5,6,7,8,2,3] />
<#assign sqlStringTypes = [1,12,-1,-15,-9] />
<#assign sqlBlobTypes = [2004,-4] />
<#assign sqlDateTypes = [91] />
<#assign lastCol = columns?last />
<#list columns as column><#if column.primaryKey><#assign keyColumn = column /><#break /></#if></#list>
<#macro insertPhpType column><#if sqlNumberTypes?seq_contains(column.dataType)>int<#elseif sqlStringTypes?seq_contains(column.dataType)>text<#elseif sqlDateTypes?seq_contains(column.dataType)>date</#if></#macro>
<#macro formItems column foreignKeys tables>
	<#assign formItemGenerated = false />
	<#list foreignKeys as fk>
		<#if fk.fkcolumnName == column.columnName>
			<#assign formItemGenerated = true />
			<#list tables as t>
				<#if t.tableName == fk.pktableName>
					<#list t.columns as c>
						<#if sqlStringTypes?seq_contains(c.dataType)>
							<#assign descriptionColumn = c />
							<#break />
						</#if>
					</#list>
					<#break />
				</#if>
			</#list>
					<mx:FormItem label="${fk.pktableName?replace("_", " ")?capitalize}:" <#if column.primaryKey>enabled="false"</#if> id="${column.columnName}_form">
						<mx:ComboBox id="${column.columnName}" labelField="<#if descriptionColumn??>${descriptionColumn.columnName}<#else>${column.columnName}</#if>" />
					</mx:FormItem>
		</#if>
	</#list>
	<#if !formItemGenerated>
		<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
					<mx:FormItem label="${column.columnName?replace("_", " ")?capitalize}:" <#if column.primaryKey>enabled="false"</#if> id="${column.columnName}_form">
					<mx:VBox>
						<mx:Image id="${column.columnName}Img" width="50" height="50" /><mx:Button label="Browse" click="uploadFile(${column.columnName}Img)" />
					</mx:VBox>
					</mx:FormItem>
		<#elseif opt.sqlDateTypes?seq_contains(column.dataType)>
					<mx:FormItem label="${column.columnName?replace("_", " ")?capitalize}:" <#if column.primaryKey>enabled="false"</#if> id="${column.columnName}_form">
						<comp:SpanishDateField id="${column.columnName}"<#if (opt.loginLogic?size > 0)><#if opt.loginLogic[2] == column.columnName> displayAsPassword="true" </#if></#if>/>
					</mx:FormItem>
		<#else>
					<mx:FormItem label="${column.columnName?replace("_", " ")?capitalize}:" <#if column.primaryKey>enabled="false"</#if> id="${column.columnName}_form">
						<mx:TextInput id="${column.columnName}"<#if (opt.loginLogic?size > 0)><#if opt.loginLogic[2] == column.columnName> displayAsPassword="true" </#if></#if>/>
					</mx:FormItem>
		</#if>
	</#if>
</#macro>
<#function getFk columna>
	<#list foreignKeys as fk>
		<#if fk.fkcolumnName == columna.columnName>
		<#return fk />
		</#if>
	</#list>
	<#return {} />
</#function>
<#function heightFromColumns>
	<#assign count = 126 />
	<#list columns as c>
		<#if sqlBlobTypes?seq_contains(c.dataType)>
			<#assign count = count + 75 />
		<#else>
			<#assign count = count + 22 />
		</#if>
	</#list>
	<#return count />
</#function>