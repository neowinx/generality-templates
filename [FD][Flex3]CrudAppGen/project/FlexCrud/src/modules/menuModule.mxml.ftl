<?xml version="1.0" encoding="utf-8"?>
<mx:Module xmlns:mx="http://www.adobe.com/2006/mxml" layout="vertical" width="400" height="300" verticalAlign="middle" horizontalAlign="center">
	<mx:Script>
		<![CDATA[
			import mx.core.Application;
		]]>
	</mx:Script>
	<mx:Panel width="250" height="256" layout="horizontal" id="pnlMenuPrincipal" title="Menu Principal" horizontalAlign="center" verticalAlign="middle">
		<mx:VBox height="100%" horizontalAlign="center" verticalAlign="middle" width="100%" verticalGap="10">
			<mx:Button label="${tableName?cap_first}" width="100%" click="Application.application.currentState='${tableName}State'"/>
		</mx:VBox>
	</mx:Panel>
</mx:Module>