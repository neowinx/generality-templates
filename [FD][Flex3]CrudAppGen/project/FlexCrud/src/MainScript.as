import flash.external.ExternalInterface;
import mx.controls.Alert;
import mx.managers.CursorManager;

private function initApp():void{
	if(ExternalInterface.available){
		ExternalInterface.call("document.getElementById('FlexCrud').setFocus()");
		this.txtUsuario.setFocus();
	}
}

public function login():void{
	CursorManager.setBusyCursor();
	/* INSERT LOGIN LOGIC HERE */
	
	//DO THIS ONLY IF AUTH LOGIC RETURNS TRUE
	currentState = 'Menu';
	CursorManager.removeBusyCursor();
	//
}