package uk.co.richtextformat.logs
{
	public class Logger
	{
		private static var callback_p:Function;
		
		public static function log (...rest):void
		{
			var debug:String = _logArray(rest);
			debug = debug.substring(1, debug.length-1);
			
			var date:Date = new Date();
			var dateStamp:String = "["+date.getHours()+":"+date.getMinutes()+":"+date.getSeconds()+":"+date.getMilliseconds()+"]";
			
			trace(dateStamp, debug);
			if (callback_p is Function) callback_p(dateStamp + ' ' + debug);
		}
		
		private static function _logArray (rest:Array):String
		{
			var debug:String = '';
			var len:int = rest.length;
			
			for (var i:int=0; i<len; i++){
				switch (true){
					case rest[i] is Array:		debug += _logArray( rest[i] );				break;
					default:					debug += _parseDebugObject( rest[i] );		break;
				}
			}
			return debug;
		}
		
		private static function _parseDebugObject (obj:*):String
		{
			var debug:String;
			
			switch (true)
			{
				case obj == null:			debug = " null";													break;
				case obj is Boolean:		debug = (obj as Boolean) ? " true" : " false";						break;
				case obj is Number:			debug = (obj as Number) == 0 ? " 0" : " " + obj.toString();			break;
				default:					debug = " " + obj.toString();
			}
			
			return debug + ',';
		}
		
		public static function set callback (value:Function):void
		{
			if (callback_p is Function) throw new Error('Logger set callback ERROR: callback function may only be set once and it has already been set.');
			callback_p = value;
		}
	}
}