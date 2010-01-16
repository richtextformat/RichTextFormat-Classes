package uk.co.richtextformat.clients.richtextformat.cellularAutomata.ui
{
	import flash.display.Graphics;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.MouseEvent;

	public class AutomataContainer extends Sprite
	{
		protected var _state:String;
		
		protected var _width:int;
		protected var _height:int;
		
		protected var _startButton:SimpleButton;
		
		protected static const OFF:String = 'OFF';
		protected static const INITING:String = 'INITING';
		protected static const ON:String = 'ON';
		
		protected static const FILL_COLOUR:int = 0xCCCCCC;
		protected static const LINE_COLOUR:int = 0x999999;
		
		public function AutomataContainer (width:int, height:int)
		{
			super();
			_init(width, height);
		}
		
		private function _init (width:int, height:int):void
		{
			_width = width;
			_height = height;
		}
		
		
		
		
		
		
		
		
		
		protected function _createStartButton ():void
		{
			var size:int = SwitchSprite.SQUARE_SIZE;
			var btnGraphics:Sprite = new Sprite();
			var gra:Graphics = btnGraphics.graphics;
			
			gra.beginFill(FILL_COLOUR);
			gra.moveTo( -(size*1.5), -(size*1.5));
			gra.lineTo(  (size*1.5), -(size*1.5));
			gra.lineTo(  (size*1.5),  (size*1.5));
			gra.lineTo( -(size*1.5),  (size*1.5));
			gra.lineTo( -(size*1.5), -(size*1.5));
			gra.endFill();
			btnGraphics.x = _width/2;
			btnGraphics.y = _height/2;
			
			gra.beginFill(0x000000);
			gra.moveTo( -(size*0.5), -(size*0.5));
			gra.lineTo( (size*0.5), 0);
			gra.lineTo( -(size*0.5), (size*0.5));
			gra.lineTo( -(size*0.5), -(size*0.5));
			gra.endFill();
			
			_startButton = new SimpleButton(btnGraphics, btnGraphics, btnGraphics, btnGraphics);
			_startButton.addEventListener(MouseEvent.MOUSE_DOWN, _onStart);
			addChild(_startButton);
		}
		
		
		
		
		
		
		protected function _onStart (me:MouseEvent):void
		{
			_state = INITING;
			
			try {
				removeChild(_startButton);
			} catch (e:Error) {}
		}
	}
}