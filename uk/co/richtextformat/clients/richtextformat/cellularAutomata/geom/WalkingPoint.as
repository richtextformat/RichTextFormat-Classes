package uk.co.richtextformat.clients.richtextformat.cellularAutomata.geom
{
	import flash.geom.Point;

	public class WalkingPoint extends Point
	{
		public var previousX:Number;
		public var previousY:Number;
		
		private var _xRecord:int;
		private var _yRecord:int;
		
		public static const LEFT:String = 'left';
		public static const RIGHT:String = 'right';
		public static const UP:String = 'up';
		public static const DOWN:String = 'down';
		public static const MIDDLE:String = 'middle';
		
		private static const MAX_RECORD:int = 1;
		
		public function WalkingPoint (x:Number=0, y:Number=0)
		{
			super(x, y);
			_init();
		}
		
		private function _init ():void
		{
			previousX = x;
			previousY = y;
			_xRecord = 0;
			_yRecord = 0;
		}
		
		public function move (direction:String, secondDirection:String = ""):void
		{
			//trace('WalkingPoint BEG',previousX,x,previousY,y);
			var dir:String;
			
			for (var i:int=0; i<2; i++){
				
				dir = i==0? direction : secondDirection;
				
				//trace('dir', dir);
				
				switch (dir){
					case LEFT:		_xRecord = _adjustRecord(_xRecord, -1);		break;
					case RIGHT:		_xRecord = _adjustRecord(_xRecord, 1);		break;
					case UP:		_yRecord = _adjustRecord(_yRecord, -1);		break;
					case DOWN:		_yRecord = _adjustRecord(_yRecord, 1);		break;
					//default:		moved = false;		break;
				}
			}
			
			previousX = x;
			previousY = y;
			x = (x + FadingWalker.RANGE + _xRecord) % FadingWalker.RANGE;
			y = (y + FadingWalker.RANGE + _yRecord) % FadingWalker.RANGE;
			
			//trace('WalkingPoint END',previousX,x,previousY,y);
		}
		
		private function _adjustRecord (record:Number, increment:Number):Number
		{
			//trace('_adjustRecord1',record, increment);
			
			var num:Number = record + increment;
			var tooHigh:int = MAX_RECORD+1;
			var tooLow:int = -tooHigh;
			
			switch (true){
				case num <= tooLow:
				case num >= tooHigh:		num = record;		break;
			}
			
			//trace('_adjustRecord2',x,y);
			return num;
		}
	}
}