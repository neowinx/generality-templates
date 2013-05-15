<#list tables as t>
CREATE SEQUENCE ${t.tableSchema}.${t.tableName}_SEQ;
</#list>