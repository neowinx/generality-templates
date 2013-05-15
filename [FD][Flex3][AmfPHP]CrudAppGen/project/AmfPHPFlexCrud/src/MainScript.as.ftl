<#import "*/gen-options.ftl" as opt>
include "modules/baseUrl.as";

import flash.external.ExternalInterface;
import mx.controls.Alert;
import mx.managers.CursorManager;
import dal.RemotingConnection;

private var gateway : RemotingConnection;

private function initApp():void{
	if(ExternalInterface.available){
		ExternalInterface.call("document.getElementById('FlexCrud').setFocus()");
	}
	this.txtUsuario.setFocus();
	gateway = new RemotingConnection(  baseUrl + "gateway.php" );
}
<#if (opt.loginLogic?size > 0) >
	<#assign loginLogicTable = opt.loginLogic[0]>
	<#assign loginLogicPasswordColumn = opt.loginLogic[2]>
public function login():void{
	CursorManager.setBusyCursor();
	gateway.call( "${loginLogicTable}.login", new Responder(loginResult, loginFault), txtUsuario.text);
}

private function loginResult(result : Array):void {
	var loginOk:Boolean = true;
	if (result == null || result.length == 0) {
		Alert.show('User ' + txtUsuario.text + ' doesnt exist.');
		loginOk = false;
	}else{
		var record:* = result.pop();
		if (record.${loginLogicPasswordColumn} != txtPassword.text) {
			Alert.show('Password incorrect.');
			loginOk = false;
		}
	}
	CursorManager.removeBusyCursor();
	if(loginOk)
		panel1.visible = false;
}

private function loginFault(fault : Object):void {
	Alert.show(fault.description);
	trace(fault.description);
	CursorManager.removeBusyCursor();
}

<#else>
public function login():void{
	CursorManager.setBusyCursor();
	/* INSERT LOGIN LOGIC HERE */
	
	//DO THIS ONLY IF AUTH LOGIC RETURNS TRUE
	panel1.visible = false;
	CursorManager.removeBusyCursor();
	//
}
</#if>