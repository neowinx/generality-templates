package dal
{
	import mx.collections.ArrayCollection;
	import mx.controls.Alert;
	import mx.managers.CursorManager;
	import mx.rpc.AsyncToken;
	import mx.rpc.events.FaultEvent;
	import mx.rpc.events.ResultEvent;
	import mx.rpc.http.HTTPService;
	
	/**
	 * Generic Data Access Layer contains the subyacent code for accessing the database from the flex 
	 * presentation layer.
	 */
	public class GenericDal
	{
		/**
		 * gateway : this is the communication layer with the server side php code
		 */
		protected var gateway:HTTPService = new HTTPService();
		
		/**
		 * the array collection holds the rows that we use in the grid
		 */
		[Bindable]
		public var dataArr:ArrayCollection = new ArrayCollection();
		
		/**
		 * column that we order by. This is updated each time the users clicks on the 
		 * grid column header. 
		 * see headerRelease="setOrder(event);" in the DataGrid instantiation in the 
		 * mxml file
		 */
		protected var orderColumn:Number;
		
		public var filter:String;
		
		/**
		 * the list of fields in the database table
		 * needed to parse the response into hashes.
		 * ALWAYS OVERRIDE THIS IN CONCRETE DAL CLASSES.
		 */ 
		protected var fields:Object = { };
		
		/**
		 * These function serves as an overriding point for the editing parameters.
		 * ALWAYS OVERRIDE THIS IN CONCRETE DAL CLASSES. 
		 */
		protected function getEditParameters():* { }
		
		/**
		 * Field that indicates if the editing mode its Insert
		 * or Update.
		 */
		public var editMode:String = "Insert";
		
		public function GenericDal()
		{
		    /**
		     * initialize the gateway
		     * - this will take care off server communication and simple xml protocol.
		     */
		    gateway.method = "POST";
		    gateway.useProxy = false;
		    gateway.resultFormat = "e4x";
		    
		    gateway.addEventListener(ResultEvent.RESULT, resultHandler);
		    gateway.addEventListener(FaultEvent.FAULT, faultHandler);
		}
		
		/** 
		 * general utility function for refreshing the data 
		 * gets the filtering and ordering, then dispatches a new server call
		 *
		 */
		public function fill():void 
		{
		    var desc:Boolean = false;
		    var orderField:String = '';
		
		    CursorManager.setBusyCursor();
		
		    var parameters:* =
		    {
		        "orderField": orderField,
		        "orderDirection": (desc) ? "DESC" : "ASC", 
		        "filter": filter
		    }
			/**
			 * execute the server "select" command
			 */
		    doRequest("FindAll", parameters, fillHandler);
		}
		
		/** 
		 * result handler for the fill call. 
		 * if it is an error, show it to the user, else refill the arraycollection with the new data
		 *
		 */
		protected function fillHandler(e:Object):void
		{
		    if (e.isError)
		    {
		        Alert.show("Error: " + e.data.error);
		    } 
		    else
		    {
		        dataArr.removeAll();
		        for each(var row:XML in e.data.row) 
		        {
		            var temp:* = {};
		            for (var key:String in fields) 
		            {
		                temp[key + 'Col'] = row[key];
		            }
		
		            dataArr.addItem(temp);
		        }
		
		        CursorManager.removeBusyCursor();
		    }    
		}
		
		protected function searchRequest(searchHandler:Function):void 
		{
		    var desc:Boolean = false;
		    var orderField:String = '';
		
		    CursorManager.setBusyCursor();
		
		    var parameters:* =
		    {
		        "orderField": orderField,
		        "orderDirection": (desc) ? "DESC" : "ASC", 
		        "filter": filter
		    }
			/**
			 * execute the server "select" command
			 */
		    doRequest("FindAll", parameters, searchHandler);
		}
		
		/**
		 * deserializes the xml response
		 * handles error cases
		 *
		 * @param e ResultEvent the server response and details about the connection
		 */
		public function deserialize(obj:*, e:*):*
		{
		    var toret:Object = {};
		    
		    toret.originalEvent = e;
		
		    if (obj.data.elements("error").length() > 0)
		    {
		        toret.isError = true;
		        toret.data = obj.data;
		    }
		    else
		    {
		        toret.isError = false;
		        toret.metadata = obj.metadata;
		        toret.data = obj.data;
		    }
		
		    return toret;
		}
		
		/**
		 * result handler for the gateway
		 * deserializes the result, and then calls the REAL event handler
		 * (set when making a request in the doRequest function)
		 *
		 * @param e ResultEvent the server response and details about the connection
		 */
		public function resultHandler(e:ResultEvent):void
		{
		    var topass:* = deserialize(e.result, e);
		    e.token.handler.call(null, topass);
		}
		
		/**
		 * fault handler for this connection
		 *
		 * @param e FaultEvent the error object
		 */
		public function faultHandler(e:FaultEvent):void
		{
			var errorMessage:String = "Connection error: " + e.fault.faultString; 
		    if (e.fault.faultDetail) 
		    { 
		        errorMessage += "\n\nAdditional detail: " + e.fault.faultDetail; 
		    } 
		    Alert.show(errorMessage);
		}
		
		/**
		 * makes a request to the server using the gateway instance
		 *
		 * @param method_name String the method name used in the server dispathcer
		 * @param parameters Object name value pairs for sending in post
		 * @param callback Function function to be called when the call completes
		 */
		public function doRequest(method_name:String, parameters:Object, callback:Function):void
		{
		    // add the method to the parameters list
		    parameters['method'] = method_name;
		
		    gateway.request = parameters;
		
		    var call:AsyncToken = gateway.send();
		    call.request_params = gateway.request;
		
		    call.handler = callback;
		}
		
		/**
		 * Click handler for the "Save" button in the "Add" state
		 * collects the information in the form and adds a new object to the collection
		 */
		public function saveItem(saveItemHandler:Function):void {
			/**
			 * execute the server "insert" or "update" command
			 */
		    doRequest(editMode, getEditParameters(), saveItemHandler);
		}
	}
}