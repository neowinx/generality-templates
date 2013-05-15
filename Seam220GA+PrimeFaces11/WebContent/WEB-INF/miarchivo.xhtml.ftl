MI TABLA ES: ${tableName}
MIS COLUMNAS SON
<#list columns as column>
        <mx:FormItem label="${column.columnName?cap_first}:" id="${column.columnName}_form">
            <mx:TextInput id="${column.columnName}Col" text=""/>
        </mx:FormItem>
</#list>