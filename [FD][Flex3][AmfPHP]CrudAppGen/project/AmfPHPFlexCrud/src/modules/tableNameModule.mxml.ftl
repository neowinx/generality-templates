<#import "*/gen-options.ftl" as opt>
<?xml version="1.0" encoding="utf-8"?>
<comp:CustomModule xmlns:mx="http://www.adobe.com/2006/mxml" xmlns:comp="components.*" creationComplete="initApplication()" minWidth="700" minHeight="550">
    <mx:Script source="${tableName}Script.as" />
	<mx:ViewStack id="applicationScreens" width="100%" height="100%" creationPolicy="all">
		<mx:VBox id="view" width="60%" height="100%" hideEffect="{MyHideEffect}" showEffect="{MyShowEffect}">
			<#list opt.filters as filter>
				<#if filter.tableName == "*" || filter.tableName == tableName>
			<mx:Form defaultButton="{getBtn}">
			<mx:Tile>
					<#list filter.columns as filterCol>
						<#if filterCol == "*">
							<#list columns as column>
				<mx:Label text="${column.columnName?replace("_", " ")?capitalize}:" /><mx:TextInput id="${column.columnName}Filter" />
							</#list>
							<#break />
						<#else>
				<mx:Label text="${filterCol?replace("_", " ")?capitalize}:" /><mx:TextInput id="${filterCol}Filter" />
						</#if>
					</#list>
			</mx:Tile>
				</#if>
			</#list>
			<#list opt.filters as filter>
				<#if filter.tableName == "*" || filter.tableName == tableName>
			<mx:Button id="getBtn" label="Search" click="get${tableName?cap_first}s()" />
			</mx:Form>
				<#break />
				</#if>
			</#list>
			<mx:DataGrid id="dataGrid" width="100%"
				dataProvider="{dataProvider}"
				rowCount="8" doubleClickEnabled="true" doubleClick="edit();"
				editable="false"
				resizableColumns="true" 
				right="10" left="10" top="10" bottom="71">
					<mx:columns>
						<#list columns as column>
							<#if opt.loginLogic?size == 0 || opt.loginLogic[2] != column.columnName>
							<#if opt.sqlBlobTypes?seq_contains(column.dataType)>
							<mx:DataGridColumn headerText="${column.columnName?replace("_", " ")?capitalize}"  dataField="${column.columnName}">
								<mx:itemRenderer>
									<mx:Component>
											<mx:Image width="25" height="25" source="{parentDocument.baseUrl + '/services/' + data.${column.columnName}}" />
									</mx:Component>
								</mx:itemRenderer>
							</mx:DataGridColumn>
							<#else>
								<#assign fk = opt.getFk(column) />
								<#if (fk?size > 0)>
									<#assign formItemGenerated = false />
									<#list tables as t>
										<#if t.tableName == fk.pktableName>
											<#list t.columns as c>
												<#if opt.sqlStringTypes?seq_contains(c.dataType)>
													<#assign formItemGenerated = true />
							<mx:DataGridColumn headerText="${c.columnName?replace("_", " ")?capitalize}" <#if c.primaryKey>visible="false"</#if> dataField="${c.columnName}" />
													<#break />
												</#if>
											</#list>
											<#break />
										</#if>
									</#list>
									<#if !formItemGenerated>
							<mx:DataGridColumn headerText="${column.columnName?replace("_", " ")?capitalize}" <#if column.primaryKey>visible="false"</#if> dataField="${column.columnName}" />
									</#if>
								<#else>
							<mx:DataGridColumn headerText="${column.columnName?replace("_", " ")?capitalize}" <#if column.primaryKey>visible="false"</#if> dataField="${column.columnName}" />
								</#if>
							</#if>
							</#if>
						</#list>
					</mx:columns>
			</mx:DataGrid>
			<mx:HBox>
				<mx:Button id="btnAddNew" icon="@Embed('../../icons/AddRecord.png')" toolTip="Add Record" click="addNew();" />
				<mx:Button id="btnEdit" icon="@Embed('../../icons/SearchRecord.png')" toolTip="Edit Record" click="edit();" />
				<mx:Button id="btnDelete" icon="@Embed('../../icons/DeleteRecord.png')" toolTip="Delete Record" click="deleteItem();"/>
				<mx:Button id="btnMenu" label="&lt;-" toolTip="Back to menu" click="Application.application.currentState='Menu'"/>
			</mx:HBox>
		</mx:VBox>
		<mx:Panel id="update" title="Edit ${tableName?replace("_", " ")?capitalize}" layout="vertical" verticalAlign="middle" horizontalAlign="center" width="100%" height="${opt.heightFromColumns()}" hideEffect="{MyHideEffect}" showEffect="{MyShowEffect}">
			<mx:Form id="${tableName}Form" height="90%" width="100%">
				<!-- mx:Tile direction="vertical" horizontalAlign="right" width="100%" height="100%" -->
				<#list columns as column>
					<@opt.formItems column foreignKeys tables />
				</#list>
				<!-- /mx:Tile -->
			</mx:Form>
			<mx:HBox height="10%" width="100%" verticalAlign="middle" horizontalAlign="center">
				<mx:Button label="Save" click="preSave();" id="btnSubmit" />
				<mx:Button label="Cancel" click="goToList();clearForm();" id="btnCancel" />
			</mx:HBox>
		</mx:Panel>
	</mx:ViewStack>
</comp:CustomModule>