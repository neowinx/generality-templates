== TABLES ==
<#list tables as t>
------------
tableName:${t.tableName!}
tableSchema:${t.tableSchema!}
  COLUMNS:
  <#list t.columns as column>
  ------------
  columnName:${column.columnName!}
  dataType:${column.dataType!}
  columnSize:${column.columnSize!}
  primaryKey:<#if column.primaryKey>Yes<#else>No</#if>
  nullable:<#if column.nullable>Yes<#else>No</#if>
  ------------
  </#list>
  FOREIGN KEYS:
  <#list t.foreignKeys as fk>
  ------------
  pktableCat:${fk.pktableCat!}
  pktableSchem:${fk.pktableSchem!}
  pktableName:${fk.pktableName!}
  pkcolumnName:${fk.pkcolumnName!}
  fktableCat:${fk.fktableCat!}
  fktableSchem:${fk.fktableSchem!}  
  fktableName:${fk.fktableName!}
  fkcolumnName:${fk.fkcolumnName!}  
  keySeq:${fk.keySeq!}
  updateRule:${fk.updateRule!}
  deleteRule:${fk.deleteRule!} 
  fkName:${fk.fkName!}
  pkName:${fk.pkName!}
  deferrability:${fk.deferrability!}
  ------------
  </#list>
------------
</#list>
=================

== Actual Table Info ==
  tableName:${tableName}
  COLUMNS:
<#list columns as column>
Nombre:${column.columnName}
Tipo:${column.dataType}
</#list>

<#list foreignKeys as fk>
pktableCat:${fk.pktableCat!}
pktableSchem:${fk.pktableSchem!}
pktableName:${fk.pktableName!}
pkcolumnName:${fk.pkcolumnName!}
fktableCat:${fk.fktableCat!}
fktableSchem:${fk.fktableSchem!}  
fktableName:${fk.fktableName!}
fkcolumnName:${fk.fkcolumnName!}  
keySeq:${fk.keySeq!}
updateRule:${fk.updateRule!}
deleteRule:${fk.deleteRule!} 
fkName:${fk.fkName!}
pkName:${fk.pkName!}
deferrability:${fk.deferrability!}
</#list>
========================