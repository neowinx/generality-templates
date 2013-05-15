import dal.RemotingConnection;
import mx.controls.Image;
import mx.events.CloseEvent;
import mx.controls.Alert;
import mx.managers.CursorManager;
import mx.managers.PopUpManager;
import mx.core.Application;

[Bindable]
private var dataProvider:Array;

private var gateway : RemotingConnection;
		
private function onResult( result : Array ) : void
{
	dataProvider = result;
}
			
private function onFault( fault : String ) : void
{
	trace( fault );
}

private function goToList():void {
	applicationScreens.selectedIndex = 0;
}

private function goToForm():void {
	applicationScreens.selectedIndex = 1;
}

private function addNew():void {
	getDataProviders();
	goToForm();
	clearForm();
}

private function assingImageUrl(img:Image, url:Number):void {
	img.source = baseUrl + '/services/' + url;
}

private function deleteItem():void {
	if (dataGrid.selectedItem != null){
		Alert.show("delete record?", "Confirmation", Alert.YES | Alert.NO, applicationScreens, confirmDelete);
	}else
		Alert.show('No row selected');
}

/**
 * Prepare data to be saved.
 */
private function preSave():void {
	processUploads();
}

private function getTypes():Array {
	//Comment out this or add/modify these arrays for type selection...
	//var allTypes:Array = new Array(getImageTypeFilter(), getTextTypeFilter());
	var allTypes:Array = new Array(getImageTypeFilter());
	return allTypes;
}

private function getImageTypeFilter():FileFilter {
	return new FileFilter("Images (*.jpg, *.jpeg, *.gif, *.png)", "*.jpg;*.jpeg;*.gif;*.png");
}

private function getTextTypeFilter():FileFilter {
	return new FileFilter("Text Files (*.txt, *.rtf)", "*.txt;*.rtf");
}

private var processingUploads:int = 0;
private var progress:components.ProgressWindow = null;

/**
 * Sends the uploaded files to the server.
 */
private function uploadFileToServer(ref:Number, oldRef:Number, ba:ByteArray):void {
	if(processingUploads == 0){
		CursorManager.setBusyCursor();
		progress = components.ProgressWindow(PopUpManager.createPopUp( applicationScreens, components.ProgressWindow , true));
		processingUploads++;
	}
	var request:URLRequest = new URLRequest ( baseUrl + 'services/upload.php?id=' + ref + '&idOld=' + oldRef );
	var loader:URLLoader = new URLLoader();
	loader.addEventListener(Event.COMPLETE, function(event:Event):void { 
		if(--processingUploads == 0){
			CursorManager.removeBusyCursor(); 
			PopUpManager.removePopUp(progress); 
			save();
		}
	} );
	request.contentType = 'application/octet-stream';
	request.method = URLRequestMethod.POST;
	request.data = ba;
	loader.load( request );
}