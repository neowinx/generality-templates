<#import "*/gen-options.ftl" as opt>
<?xml version="1.0" encoding="utf-8"?>
<mx:Module xmlns:mx="http://www.adobe.com/2006/mxml" layout="horizontal" minWidth="500" width="100%" height="100%" creationComplete="${tableName}Dal.fill()">
    <#list columns as column>
    <mx:Binding source="${column.columnName}Col.text" destination="${tableName}Dal.${column.columnName}" />
    </#list>
    <mx:Script source="${tableName}Script.as" />
	<mx:ViewStack id="applicationScreens" width="100%" height="100%" creationPolicy="all">
		<mx:VBox id="view" width="60%" height="100%">
			<mx:DataGrid id="dataGrid" width="100%"
				dataProvider="{${tableName}Dal.dataArr}"
				rowCount="8"
				editable="false"
				resizableColumns="true" 
				right="10" left="10" top="10" bottom="71">
					<mx:columns>
						<#list columns as column>
							<mx:DataGridColumn headerText="${column.columnName}" <#if column.primaryKey>visible="false"</#if> dataField="${column.columnName}Col" />
						</#list>
					</mx:columns>
			</mx:DataGrid>
			<mx:HBox>
				<mx:Button id="btnAddNew" icon="@Embed('../icons/AddRecord.png')" toolTip="Add Record" x="10" bottom="10" click="addNew();" />
				<mx:Button id="btnEdit" icon="@Embed('../icons/SearchRecord.png')" toolTip="Edit Record" x="10" bottom="10" click="edit();" />
				<mx:Button id="btnDelete" icon="@Embed('../icons/DeleteRecord.png')" toolTip="Delete Record" x="58" bottom="10" click="deleteItem();"/>
			</mx:HBox>
		</mx:VBox>
		<mx:Panel id="update" title="Edit ${tableName?cap_first}" layout="vertical" verticalAlign="middle" horizontalAlign="center" width="70%" height="100%">
			<mx:Form id="${tableName}Form" height="100%">
				<mx:Tile direction="vertical" horizontalAlign="right">
				<#list columns as column>
					<mx:FormItem label="${column.columnName?cap_first}:" <#if column.primaryKey>visible="false"</#if> id="${column.columnName}_form">
						<mx:TextInput id="${column.columnName}Col" text="{${tableName}Dal.${column.columnName}}"/>
					</mx:FormItem>
				</#list>
				</mx:Tile>
			</mx:Form>
			<mx:HBox>
				<mx:Button label="Save" click="save();" id="btnSubmit" right="81" bottom="10"/>
				<mx:Button label="Cancel" click="applicationScreens.selectedIndex = 0;${tableName}Dal.clearFields();" id="btnCancel" right="10" bottom="10"/>
			</mx:HBox>
		</mx:Panel>
	</mx:ViewStack>
</mx:Module>