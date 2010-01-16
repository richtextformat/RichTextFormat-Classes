package uk.co.richtextformat.clients.richtextformat.cellularAutomata.grids
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class AbstractGrid extends EventDispatcher
	{
		public var width:int;
		public var height:int;
		
		protected var _timer:Timer;
		
		protected static const MAX_FLAGS_TO_CALCULATE_PER_FRAME:int = 4096;
		
		
		
		public function AbstractGrid (target:IEventDispatcher=null)
		{
			super(target);
		}
		
		
		public function populateGrid (frameRate:int):void
		{
			trace("populateGrid", _initialise);
			_timer = new Timer(frameRate);
			_timer.addEventListener(TimerEvent.TIMER, _initialise);
			_timer.start();
		}
		
		
		
		
		
		protected function _initialise (event:TimerEvent):void
		{
			trace('AbstractGrid _initialise method probably needs overriding');
		}
	}
}