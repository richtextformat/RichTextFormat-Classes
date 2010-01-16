package uk.co.richtextformat.localisation
{
	import flash.events.EventDispatcher;
 
	public class DispatchingObject extends EventDispatcher
	{
		private var _object:Object;
		
		public function DispatchingObject ():void
		{
			_object = new Object();
		}
 
		[Bindable]
		public function get object():Object { return _object; }
		public function set object(object:Object):void
		{
			_object = object;
			dispatchEvent( new Event(Event.CHANGE) );
		}
	}
}