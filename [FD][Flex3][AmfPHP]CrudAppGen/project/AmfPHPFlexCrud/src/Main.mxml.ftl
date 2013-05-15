<#import "*/gen-options.ftl" as opt>
<?xml version="1.0" encoding="utf-8"?>
<mx:Application xmlns:mx="http://www.adobe.com/2006/mxml"  xmlns:comp="components.*" layout="vertical" horizontalAlign="center" verticalAlign="middle"
	creationComplete="initApp()" paddingBottom="0" paddingLeft="0" paddingRight="0" paddingTop="0">
	<mx:Script source="MainScript.as" />
	<mx:states>
		<mx:State name="Menu">
			<mx:AddChild>
				<comp:CustomModuleLoader url="menuModule.swf"  id="menuModuleLoader"/>
			</mx:AddChild>
			<mx:RemoveChild target="{panel1}"/>
		</mx:State>
		<#list tables as t><mx:State name="${t.tableName}State">
			<mx:AddChild>
				<comp:CustomModuleLoader url="${t.tableName}Module.swf" id="${t.tableName}ModuleLoader"/>
			</mx:AddChild>
			<mx:RemoveChild target="{panel1}"/>
		</mx:State>
		</#list>
	</mx:states>
    <mx:Parallel id="ZoomRotateHide">
            <mx:Rotate id="myRotateHide"/>
            <mx:Zoom id="myZoomHide" 
                zoomHeightFrom="1.0" 
                zoomWidthFrom="1.0" 
                zoomHeightTo="0.0" 
                zoomWidthTo="0.0"
				tweenEnd="{currentState = 'Menu'}"
             />
    </mx:Parallel>
	<mx:ApplicationControlBar dock="true" id="applicationcontrolbar1">
		<mx:Label text="${opt.applicationTitle}" color="#FFFFFF" fontWeight="bold" fontStyle="normal" fontSize="14"/>
	</mx:ApplicationControlBar>
	<mx:Panel width="304" height="200" layout="vertical" title="Login" verticalAlign="middle" horizontalAlign="center" horizontalGap="50" id="panel1" hideEffect="{ZoomRotateHide}">
		<mx:Form width="100%" height="100%" id="frmLogin" label="Login">
			<mx:FormItem label="Usuario">
				<mx:TextInput width="100%" height="100%" id="txtUsuario"/>
			</mx:FormItem>
			<mx:FormItem label="Password">
				<mx:TextInput width="100%" height="100%" id="txtPassword" displayAsPassword="true"/>
			</mx:FormItem>
			<mx:FormItem>
				<mx:Button label="Ingresar" id="btnIngresar" click="login();"/>
			</mx:FormItem>
		</mx:Form>
	</mx:Panel>
</mx:Application>