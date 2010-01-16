package uk.co.richtextformat.data
{
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class RiceArray extends Array
	{
		private var initTimer:Timer;
		private var tmpRest:Array;
		
		public function RiceArray (...rest)
		{
			super(rest.length);
			trace('RiceArray', rest.length);
			init(rest);
		}
		
		private function init (rest:Array = null):void
		{
			if (rest is Array){
				tmpRest = rest;
				initTimer = new Timer(1);
				initTimer.addEventListener(TimerEvent.TIMER, onInitTimerTick);
				initTimer.start();
			}
		}
		
		private function onInitTimerTick (event:TimerEvent):void
		{
			trace('onInitTimerTick', length)
			if (length){
				initTimer.stop();
				initTimer.removeEventListener(TimerEvent.TIMER, onInitTimerTick);
				initTimer = null;
				var len:int = tmpRest.length;
				for (var i:int=0; i<len; i++) this[i] = tmpRest.shift();
				tmpRest = null;
			}
		}
		
		public function snap ():Array
		{
			var breakpoint:int = 1 + int( Math.random() * (length - 1) );
			return splice(breakpoint, length - breakpoint);
		}
		
		public function crackle ():void
		{
			var tmp:*;
			var indexA:int;
			var indexB:int;
			var len:int = length * 2;
			
			for (var i:int=0; i<len; i++){
				indexA = getRandomIndex();
				indexB = getRandomIndex();
				tmp = this[indexA];
				this[indexA] = this[indexB];
				this[indexB] = tmp;
			}
		}
		
		private function getRandomIndex ():int
		{
			return int( Math.random() * (length + 0.9) );
		}
	}
}