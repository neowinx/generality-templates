<#import "*/gen-options.ftl" as opt>
package dal
{
    import mx.managers.CursorManager;
    import mx.controls.Alert;
    
	[Bindable]
	public class ${tableName?cap_first}Dal extends GenericDal
	{
		<#list columns as column>
		private var _${column.columnName}:String;
		</#list>
		
		public function ${tableName?cap_first}Dal()
		{
			super();
			gateway.url = "${opt.serverUrl}${tableName}.php";
			fields = {<@opt.fieldsPrint columns=columns />};
		}

		<#list columns as column>
		public function set ${column.columnName}(value:String):void{
			_${column.columnName} = value;
		}
		public function get ${column.columnName}():String{
			return _${column.columnName};
		}
		
		</#list>
		
		private var searchCallBack:Function;
		
		public function search(callBack:Function):void {
			searchCallBack = callBack;
			super.searchRequest(searchHandler);
		}
		
		private function searchHandler(e:Object):void {
		    if (e.isError)
		    {
		        Alert.show("Error: " + e.data.error);
		    } 
		    else
		    {
		        for each(var row:XML in e.data.row) 
		        {<#list columns as column>
		            this.${column.columnName} = row['${column.columnName}'];</#list>
		        }
				searchCallBack.call(e);
		    }
		    filter = null;
			CursorManager.removeBusyCursor();
		}
		
		override protected function getEditParameters():* {
			return {"method": editMode<#list columns as column>, "${column.columnName}":_${column.columnName}</#list>};
		}
		
		public function clearFields():void {
			<#list columns as column>
			${column.columnName} = null;
			</#list>
		}
	}
}