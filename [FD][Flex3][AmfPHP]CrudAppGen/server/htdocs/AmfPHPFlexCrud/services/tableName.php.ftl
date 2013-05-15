<#import "*/gen-options.ftl" as opt>
<?php
class ${tableName}
{
    function ${tableName} () 
	{
        $this->methodTable = array(
            "get${tableName?cap_first}s" => array(
                "description" => "Return a list of ${tableName}s",
<#list opt.filters as filter>
	<#if filter.tableName == "*" || filter.tableName == tableName>
				"arguments" => array(<#rt>
		<#lt><#list filter.columns as filterCol>
			<#if filterCol == "*">
				<#list columns as column>
<#t>"${column.columnName}Filter"<#if column != columns?last>,</#if>
				</#list>
				<#break>
			<#else>
<#t>"${filterCol}Filter"<#if filterCol != filter.columns?last>,</#if>
			</#if>
		<#lt></#list>),
	</#if>
</#list>
                "access" => "remote"
            ),
			"dataProvider" => array(
                "description" => "Return a list of id and description fields for dataproviders",
                "access" => "remote"
            ),
            <#if (opt.loginLogic?size > 0) && opt.loginLogic[0] == tableName>
			"login" => array(
                "description" => "Returns user and password for login infromation",
				"arguments" => array("${opt.loginLogic[1]}"),
                "access" => "remote"
            ),
            </#if>
            "insert" => array(
                "description" => "Insert a ${tableName}",
				"arguments" => array(<#list columns as column><#if !column.primaryKey>"${column.columnName}"<#if column != columns?last>,</#if></#if></#list>),
                "access" => "remote"
            ),
            "update" => array(
                "description" => "Update a ${tableName}",
				"arguments" => array("${opt.keyColumn.columnName}"<#list columns as column><#if !column.primaryKey>, "${column.columnName}"</#if></#list>),
                "access" => "remote"
            ),
            "delete" => array(
                "description" => "Delete a ${tableName}",
				"arguments" => array("${opt.keyColumn.columnName}"),
                "access" => "remote"
            ),
            "edit" => array(
                "description" => "Retrieve data for a edited record",
				"arguments" => array("${opt.keyColumn.columnName}"),
                "access" => "remote"
            )
        );
    }

    function get${tableName?cap_first}s (<#rt>
<#lt><#list opt.filters as filter>
	<#if filter.tableName == "*" || filter.tableName == tableName>
		<#list filter.columns as filterCol>
			<#if filterCol == "*">
				<#list columns as column>
	<#t>$${column.columnName}Filter<#if column != columns?last>,</#if>
				</#list>
				<#break>
			<#else>
	<#t>$${filterCol}Filter<#if filterCol != filter.columns?last>,</#if>
			</#if>
		</#list>
	</#if>
</#list>
<#lt>) {
    	global $mysql;
    	
    	//return a list of all the ${tableName}s
		$Query = sprintf("SELECT ${tableName}.${opt.keyColumn.columnName}<#rt>
		<#list columns as column>
			<#if !column.primaryKey>
				<#assign fk = opt.getFk(column)>
				<#if (fk?size > 0)>
					<#assign formItemGenerated = false>
					<#list tables as t>
						<#if t.tableName == fk.pktableName>
							<#list t.columns as c>
								<#if opt.sqlStringTypes?seq_contains(c.dataType)>
									<#assign formItemGenerated = true>
									,${fk.fkcolumnName}.${c.columnName}<#t>
									<#break />
								</#if>
							</#list>
							<#break />
						</#if>
					</#list>
					<#if !formItemGenerated>
						,${tableName}.${column.columnName}<#t>
					</#if>
				<#else>
				,${tableName}.${column.columnName}<#t>
				</#if>
			</#if>
		</#list> from ${tableName}<#t>
		<#list columns as column>
			<#assign fk = opt.getFk(column)>
			<#if (fk?size > 0)>
			left outer join ${fk.pktableName} ${fk.fkcolumnName} on ${tableName}.${column.columnName} = ${fk.fkcolumnName}.${fk.pkcolumnName}
			</#if>
		</#list>
<#list opt.filters as filter>
	<#if filter.tableName == "*" || filter.tableName == tableName>
			where <#rt>
		<#list filter.columns as filterCol>
			<#if filterCol == "*">
				<#list columns as column>
			<#lt> ${tableName}.${column.columnName} LIKE %s <#if filterCol != filter.columns?last>AND</#if><#rt>
				</#list>
				<#break>
			<#else>
			<#lt> ${tableName}.${filterCol} LIKE %s <#if filterCol != filter.columns?last>AND</#if><#rt>
			</#if>
		</#list>
	</#if>
</#list>"<#t>
<#list opt.filters as filter>
	<#if filter.tableName == "*" || filter.tableName == tableName>
		<#list filter.columns as filterCol>
			<#if filterCol == "*">
				<#list columns as column>
	<#lt>,GetSQLValueString($${column.columnName}Filter."%","text")<#rt>
				</#list>
				<#break>
			<#else>
	<#lt>,GetSQLValueString($${filterCol}Filter."%","text")<#rt>
			</#if>
		</#list>
	</#if>
</#list>);
		$Result = mysql_query( $Query );
		while ($row = mysql_fetch_object($Result)) {
   			$return[] = $row;
		}
		return( $return );
	}
	
    function dataProvider () {
    	global $mysql;
    	
		$Query = "SELECT ${opt.keyColumn.columnName}<#list columns as column><#if !column.primaryKey && opt.sqlStringTypes?seq_contains(column.dataType)>,${column.columnName}<#break /></#if></#list> from ${tableName}";
		$Result = mysql_query( $Query );
		while ($row = mysql_fetch_object($Result)) {
   			$return[] = $row;
		}
		return( $return );
	}
<#if (opt.loginLogic?size > 0) && opt.loginLogic[0] == tableName>
    function login ($${opt.loginLogic[1]}) {
    	global $mysql;
		
		$Query = sprintf("SELECT ${opt.loginLogic[1]}, ${opt.loginLogic[2]} FROM `${opt.loginLogic[0]}` WHERE ${opt.loginLogic[1]} = %s", 
			GetSQLValueString($${opt.loginLogic[1]}, "text"));
			
		$Result = mysql_query($Query, $mysql);
		
		while ($row = mysql_fetch_object($Result)) {
   			$return[] = $row;
		}
		return( $return );
	}
</#if>
	function insert(<#list columns as column><#if !column.primaryKey>$${column.columnName}<#if column != columns?last>,</#if></#if></#list>){
		global $mysql;
		
		$query_insert = sprintf("INSERT INTO `${tableName}` (<#list columns as column><#if !column.primaryKey>${column.columnName}<#if column != columns?last>, </#if></#if></#list>) VALUES (<#list columns as column><#if !column.primaryKey>%s<#if column != columns?last>, </#if></#if></#list>)" , <#list columns as column><#if !column.primaryKey>GetSQLValueString($${column.columnName}, "<@opt.insertPhpType column />")<#if column != columns?last>, </#if></#if></#list>);
		$ok = mysql_query($query_insert, $mysql);
		
		if(!$ok)
			return mysql_error();
	
		return $ok;
	}
	
	function update($${opt.keyColumn.columnName}<#list columns as column><#if !column.primaryKey>, $${column.columnName}</#if></#list>){
		global $mysql;

		$query_update = sprintf("UPDATE `${tableName}` SET <#list columns as column><#if !column.primaryKey>${column.columnName} = %s<#if column != columns?last>, </#if></#if></#list> WHERE ${opt.keyColumn.columnName} = %s", 
			<#list columns as column><#if !column.primaryKey>GetSQLValueString($${column.columnName}, "<@opt.insertPhpType column />"),</#if></#list>
			GetSQLValueString($${opt.keyColumn.columnName}, "<@opt.insertPhpType opt.keyColumn />")
		);
		$ok = mysql_query($query_update, $mysql);
		
		if(!$ok)
			return mysql_error();
	
		return $ok;
	}
	
    function edit ($${opt.keyColumn.columnName}) {
    	global $mysql;

		$Query = sprintf("SELECT * from ${tableName} WHERE ${opt.keyColumn.columnName} = %s",
			GetSQLValueString($${opt.keyColumn.columnName}, "<@opt.insertPhpType opt.keyColumn />"));
		$Result = mysql_query( $Query );
		while ($row = mysql_fetch_object($Result)) {
   			$return[] = $row;
		}
		return( $return );
	}
	
    function delete ($${opt.keyColumn.columnName}) {
    	global $mysql;
		
		$query_delete = sprintf("DELETE FROM `${tableName}` WHERE ${opt.keyColumn.columnName} = %s", 
			GetSQLValueString($${opt.keyColumn.columnName}, "<@opt.insertPhpType opt.keyColumn />"));
			
		$ok = mysql_query($query_delete, $mysql);
		
		if(!$ok)
			return mysql_error();
	
		return $ok;
	}
}
?>