<#import "*/gen-options.ftl" as opt>
import mx.controls.DateField;
include "crudModuleScript.as";
include "baseUrl.as";

/**
 * Data providers value holders.
 */
<#list columns as column>
	<#list foreignKeys as fk>
		<#if fk.fkcolumnName == column.columnName>
private var ${column.columnName}_vh:*;
		<#break />
		</#if>
	</#list>
</#list>
/**
 * Blob columns reference holders
 * Ej.: private var fotografia:Number; 
 */
<#list columns as column><#if opt.sqlBlobTypes?seq_contains(column.dataType)>private var ${column.columnName}:Number;</#if></#list>
/**
 * Blob columns references holders to old data.
 * Ej.: private var fotografia2Old:Number;
 */
<#list columns as column><#if opt.sqlBlobTypes?seq_contains(column.dataType)>private var ${column.columnName}Old:Number;</#if></#list>
/**
 * Initialize remoting connection and do a first request to the server
 */
private function initApplication():void
{
	gateway = new RemotingConnection(  baseUrl + "gateway.php" );
	get${tableName?cap_first}s();
}

private function get${tableName?cap_first}s():void {
	gateway.call( "${tableName}.get${tableName?cap_first}s", new Responder(onResult, onFault)
			<#list opt.filters as filter>
				<#if filter.tableName == "*" || filter.tableName == tableName>
					<#list filter.columns as filterCol>
						<#if filterCol == "*">
							<#list columns as column>
				,${column.columnName}Filter.text
							</#list>
							<#break />
						<#else>
				,${filterCol}Filter.text
						</#if>
					</#list>
				</#if>
			</#list>
	);
}

/**
 * Clear the forma data.
 */
private function clearForm():void {
	<#list columns as column>
	<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
	${column.columnName} = 0;
	${column.columnName}Old = 0;
	<#else>
		<#assign fk = opt.getFk(column) />
		<#if (fk?keys?size > 0)>
	${column.columnName}_vh = null;
		<#else>
	${column.columnName}.text = null;
		</#if>
	</#if>
	</#list>
}

private function edit():void {
	if(dataGrid.selectedItem != null)
		gateway.call( "${tableName}.edit", new Responder(editResult, editFault), dataGrid.selectedItem.${opt.keyColumn.columnName});
	else
		Alert.show("No row selected.");
}

private function editResult(result : Array):void {
	var record:* = result.pop();
	<#list columns as column>
	<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
	${column.columnName} = record.${column.columnName};
	${column.columnName}Old = record.${column.columnName};
	assingImageUrl(${column.columnName}Img, ${column.columnName});
	<#elseif opt.sqlDateTypes?seq_contains(column.dataType)>
	${column.columnName}.selectedDate = DateField.stringToDate(record.${column.columnName}, "YYYY-MM-DD");
	<#else>
		<#assign fk = opt.getFk(column) />
		<#if (fk?keys?size > 0)>
	${column.columnName}_vh = record.${column.columnName};
		<#else>
	${column.columnName}.text = record.${column.columnName};
		</#if>
	</#if>
	</#list>
	getDataProviders();
	goToForm();
}

private function getDataProviders():void {
	<#list columns as column>
		<#assign fk = opt.getFk(column) />
		<#if (fk?keys?size > 0)>
	gateway.call("${fk.pktableName}.dataProvider", new Responder(function(result:Array):void { ${column.columnName}.dataProvider = result; setupProvidedData(); }, function():void { Alert.show('Error obtaining data provider for ${fk.pktableName}s.'); } ));
		</#if>
	</#list>
}

private function setupProvidedData():void {
	var i:int = 0;
	var record:* = null;
	<#list columns as column>
		<#assign fk = opt.getFk(column) />
		<#if (fk?keys?size > 0)>
	for (i = 0; i < ${column.columnName}.dataProvider.source.length; i ++) {
		record = ${column.columnName}.dataProvider.source[i];
		if (record.${fk.pkcolumnName} == ${column.columnName}_vh){
			${column.columnName}.selectedItem = record;
			break;
		}
	}
		</#if>
	</#list>
}

private function editFault(fault : Object):void {
	Alert.show(fault.description);
	trace(fault.description);
}

private function confirmDelete(evt:CloseEvent):void {
	if (evt.detail == Alert.YES)
		gateway.call( "${tableName}.delete", new Responder(saveResult, saveFault), dataGrid.selectedItem.${opt.keyColumn.columnName});
}

/**
 * Do the actual save operation on the server.
 */
private function save():void {
	if(${opt.keyColumn.columnName}.text == "")
		gateway.call( "${tableName}.insert", new Responder(saveResult, saveFault), <@compress single_line=true>
		<#list columns as column>
			<#if !column.primaryKey>
				<#assign fk = opt.getFk(column) />
				<#if (fk?keys?size > 0)>
					${column.columnName}.selectedItem.${fk.pkcolumnName}
				<#else>
					<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
						${column.columnName}
					<#elseif opt.sqlDateTypes?seq_contains(column.dataType)>
						DateField.dateToString(${column.columnName}.selectedDate,"YYYY-MM-DD")
					<#else>
						${column.columnName}.text
					</#if>
				</#if><#t />
				<#if column != columns?last>,</#if>
			</#if>
		</#list>
</@compress>);	
	else
		gateway.call( "${tableName}.update", new Responder(saveResult, saveFault), ${opt.keyColumn.columnName}.text, <@compress single_line=true>
		<#list columns as column>
			<#if !column.primaryKey>
				<#assign fk = opt.getFk(column) />
				<#if (fk?keys?size > 0)>
					${column.columnName}.selectedItem.${fk.pkcolumnName}
				<#else>
					<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
						${column.columnName}
					<#elseif opt.sqlDateTypes?seq_contains(column.dataType)>
						DateField.dateToString(${column.columnName}.selectedDate,"YYYY-MM-DD")
					<#else>
						${column.columnName}.text
					</#if>
				</#if><#t />
				<#if column != columns?last>,</#if>
			</#if>
		</#list>
</@compress>);
}

private function saveResult(result:*):void {
	if (result is Boolean && result) {
		get${tableName?cap_first}s();
		goToList();
	}else if (result is String)
		Alert.show(result);
	else
		Alert.show("Unknow error.");
	trace(result);
}

private function saveFault(fault : Object):void {
	Alert.show(fault.description);
	trace(fault.description);
}

private function uploadFile(img:Image):void {
	var fr:FileReference = new FileReference();
	fr.addEventListener(Event.SELECT, function(e:Event):void { 
		fr.addEventListener(Event.COMPLETE, function(e:Event):void {
			img.source = fr.data;
			<#list columns as column>
			<#if !column.primaryKey>
			<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
			if(img.id == '${column.columnName}Img')
				${column.columnName} = new Date().time;
			</#if>
			</#if>
			</#list>
		});
		fr.load(); 
	} );
	fr.browse(getTypes());
}

/**
 * Process uploaded files before save()
 */
private function processUploads():void {
	var hasUploads:Boolean = false;
	<#list columns as column>
	<#if !column.primaryKey>
	<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
	if (${column.columnName} != ${column.columnName}Old){
		uploadFileToServer(${column.columnName}, ${column.columnName}Old, ${column.columnName}Img.source as ByteArray);
		hasUploads = true;
	}
	</#if>
	</#if>
	</#list>
	if (!hasUploads)
		save();
}