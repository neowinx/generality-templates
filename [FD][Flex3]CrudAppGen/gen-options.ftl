<#-- CHANGE THESE SETTINGS ACCORDING TO YOUR ENV -->
<#assign serverDir = "D:\\xampplite\\htdocs\\FlexCrud">
<#assign serverUrl = "http://localhost/FlexCrud/">
<#assign flexSDKHome = "D:\\flex341">
<#macro connectionSettings>
$hostname_conn = "localhost";
$database_conn = "btc";
$username_conn = "root";
$password_conn = "";
</#macro>

<#-- LEAVE THESE SETTINGS ALONE!!! DONT CHANGE ANYTHING FROM HERE -->
<#assign sqlNumberTypes = [-7,-6,5,4,-5,6,7,8,2,3] >
<#assign sqlStringTypes = [1,12,-1,-15,-9]>
<#assign lastCol = columns?last>
<#list columns as column><#if column.primaryKey><#assign keyColumn = column><#break /></#if></#list>

<#macro fieldsPrint columns>
<#list columns as column><#if sqlNumberTypes?seq_contains(column.dataType)>'${column.columnName}':Number<#elseif sqlStringTypes?seq_contains(column.dataType)>'${column.columnName}':String</#if><#if column != lastCol>,</#if></#list>
</#macro>

<#macro insertColumns>
<#list columns as column><#if !column.primaryKey>${column.columnName}<#if column != lastCol>,</#if></#if></#list></#macro>

<#macro insertValues>
<#list columns as column><#if !column.primaryKey>%s<#if column != lastCol>,</#if></#if></#list></#macro>

<#macro insertParameters>
<#list columns as column><#if !column.primaryKey>GetSQLValueString($_REQUEST["${column.columnName}"], "<#if sqlNumberTypes?seq_contains(column.dataType)>int<#elseif sqlStringTypes?seq_contains(column.dataType)>text</#if>")<#if column != lastCol>,</#if></#if></#list></#macro>

<#macro insertPhpType column><#if sqlNumberTypes?seq_contains(column.dataType)>int<#elseif sqlStringTypes?seq_contains(column.dataType)>text</#if></#macro>