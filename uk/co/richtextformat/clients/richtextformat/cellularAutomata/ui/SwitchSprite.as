package uk.co.richtextformat.clients.richtextformat.cellularAutomata.ui
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.display.Sprite;

	public class SwitchSprite extends Sprite
	{
		private var _indices:Array;
		private var _bitmap:BitmapData;
		private var _switch:Bitmap;
		
		public static const SQUARE_SIZE:int = 12;
		public static const SQUARE_GAP:int = 3;
		
		public function SwitchSprite (index0:int, index1:int, index2:int)
		{
			super();
			_init(index0, index1, index2);
		}
		
		private function _init (index0:int, index1:int, index2:int):void
		{
			this.name = "SwitchSprite_" + index0 + index1 + index2;
			
			_indices = new Array(3);
			_indices[0] = index0;
			_indices[1] = index1;
			_indices[2] = index2;
			
			var len:int = _indices.length;
			for (var i:int=0; i<len; i++){
				_createSquare(_indices[i] * 0xFFFFFF, i);
			}
			
			_createBitmap();
			setColour(0xFFFFFF);
		}
		
		private function _createSquare (col:int, pos:int):void
		{
			var baseX:int = pos * SQUARE_SIZE;
			
			var gra:Graphics = this.graphics;
			gra.beginFill(col);
			gra.moveTo(baseX,0);
			gra.lineTo(baseX+SQUARE_SIZE,0);
			gra.lineTo(baseX+SQUARE_SIZE,SQUARE_SIZE);
			gra.lineTo(baseX,SQUARE_SIZE);
			gra.lineTo(baseX,0);
			gra.endFill();
		}
		
		private function _createBitmap ():void
		{
			_bitmap = new BitmapData(SQUARE_SIZE, SQUARE_SIZE, false, 0xFF000000);
			_switch = new Bitmap(_bitmap);
			_switch.x = SQUARE_SIZE;
			_switch.y = SQUARE_SIZE + SQUARE_GAP;
			
			addChild(_switch);
		}
		
		
		
		
		
		
		
		
		
		public function setColour (col:int):void
		{
			_bitmap.fillRect(_bitmap.rect, col);
		}
	}
}