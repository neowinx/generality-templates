<#import "*/gen-options.ftl" as opt>
import dal.${tableName?cap_first}Dal;
import mx.controls.Alert;
import mx.events.CloseEvent;

[Bindable]
private var ${tableName}Dal:${tableName?cap_first}Dal = new ${tableName?cap_first}Dal();

private function addNew():void {
	${tableName}Dal.clearFields();
	applicationScreens.selectedIndex = 1;
}

private function edit():void {
	if (dataGrid.selectedItem != null) {
		${tableName}Dal.filter = dataGrid.selectedItem.${opt.keyColumn.columnName}Col;
		${tableName}Dal.search(editHandler);
	}else
		Alert.show('No row selected');
}

private function editHandler():void {
	applicationScreens.selectedIndex = 1;
}

private function save():void {
	if(${tableName}Dal.${opt.keyColumn.columnName} == null)
		${tableName}Dal.editMode = "Insert";
	else
		${tableName}Dal.editMode = "Update";
	${tableName}Dal.saveItem(saveItemHandler);
}

private function saveItemHandler(e:Object):void
{
	if (e.isError)
	{
		Alert.show("Error: " + e.data.error);
	}
	else
	{
		${tableName}Dal.fill();
		applicationScreens.selectedIndex = 0;
		${tableName}Dal.clearFields();
	}
}

private function deleteItem():void {
	if (dataGrid.selectedItem != null){
		${tableName}Dal.${opt.keyColumn.columnName} = dataGrid.selectedItem.${opt.keyColumn.columnName}Col;
		Alert.show("delete record?", "Confirmation", Alert.YES | Alert.NO, applicationScreens, confirmDelete);
	}else
		Alert.show('No row selected');
}

private function confirmDelete(evt:CloseEvent):void {
	if (evt.detail == Alert.YES) {
		${tableName}Dal.editMode = "Delete";
		${tableName}Dal.saveItem(saveItemHandler);
	}
}