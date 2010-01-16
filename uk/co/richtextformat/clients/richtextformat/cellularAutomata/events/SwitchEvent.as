package uk.co.richtextformat.clients.richtextformat.cellularAutomata.events
{
	import flash.events.Event;

	public class SwitchEvent extends Event
	{
		public var flag:int;
		public var index0:int;
		public var index1:int;
		public var index2:int;
		
		public static const TOGGLED:String = 'toggled';
		
		public function SwitchEvent(type:String, flag:int, index0:int, index1:int, index2:int, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			
			this.flag = flag;
			this.index0 = index0;
			this.index1 = index1;
			this.index2 = index2;
		}
		
		override public function clone():Event
		{
			return new SwitchEvent(type, flag, index0, index1, index2, bubbles, cancelable);
		}
	}
}