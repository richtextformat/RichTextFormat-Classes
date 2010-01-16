package uk.co.richtextformat.events
{
	import flash.events.Event;

	public class DataEvent extends Event
	{
		private var _data:Object;
		
		private static const PREFIX:String = 'DataEvent::';
		
		public static const DATA_TRANSFER:String = PREFIX + 'DataTransfer';
		
		public function DataEvent (type:String, data:Object = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_data = data;
		}
		
		public function get data ():Object { return _data; }
		
		override public function clone ():Event
		{
			return new DataEvent(type, _data, bubbles, cancelable);
		}
	}
}