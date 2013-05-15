<?xml version="1.0" encoding="utf-8"?>
<comp:CustomModule xmlns:mx="http://www.adobe.com/2006/mxml" xmlns:comp="components.*" layout="vertical" width="500" height="550" verticalAlign="middle" horizontalAlign="center">
	<mx:Script>
		<![CDATA[
			import mx.core.Application;
			import mx.effects.SetPropertyAction;
			
			private var stateName:String;
			
			private function goTo():void{
				Application.application.currentState = stateName;
			}
			
		]]>
	</mx:Script>
	<mx:Parallel id="ZoomRotateShow">
            <mx:Zoom id="myZoomShow" 
                zoomHeightFrom="0.0"  
                zoomWidthFrom="0.0" 
                zoomHeightTo="1.0" 
                zoomWidthTo="1.0"
            />
            <mx:Rotate id="myRotateShow"/>
    </mx:Parallel>
	<mx:Zoom id="myZoomHide" 
		zoomHeightFrom="1.0" 
		zoomWidthFrom="1.0" 
		zoomHeightTo="0.0" 
		zoomWidthTo="0.0" tweenEnd="goTo()"/>
	<mx:Panel width="100%" height="100%" layout="horizontal" id="pnlMenuPrincipal" title="Menu Principal" horizontalAlign="center" verticalAlign="middle" creationCompleteEffect="{ZoomRotateShow}" hideEffect="{myZoomHide}" effectEnd="pnlMenuPrincipal.visible=true;">
		<mx:VBox height="100%" horizontalAlign="center" verticalAlign="middle" width="100%" verticalGap="10">
			<#list tables as t>
			<mx:Button label="${t.tableName?replace("_", " ")?capitalize}" width="100%" click="stateName='${t.tableName}State';pnlMenuPrincipal.visible=false;"/>
			</#list>
		</mx:VBox>
	</mx:Panel>
</comp:CustomModule>