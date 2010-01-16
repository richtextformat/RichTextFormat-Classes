package uk.co.richtextformat.flex.view.components.carousel
{
	import mx.containers.Canvas;
	import mx.controls.Text;
	
	import uk.co.richtextformat.logs.Logger;
	
	public class CarouselFocusFrame extends Canvas implements ICarouselFocusFrame
	{
		// ------------------------------------------------------------------------------------------------------------------------------
		// CONSTANTS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________constants:int;
		
		protected var title_p:Text;
	//	protected var background_p:Sprite;
	//	protected var image_p:Image;
	//	protected var source_p:Bitmap;
	
		private var data_p:CarouselRendererData;
		
		private static const NAMESPACE:String = 'CarouselFocusFrame::';
		
	//	public static const :String = NAMESPACE + '';
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// INIT METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________initMethods:int;
		
		public function CarouselFocusFrame ():void
		{
			super();
			init();
		}
		
		private function init ():void
		{
			measure();
			clipContent = false;
		//	reset();
		}
		
	/* 	public function reset ():void
		{
			
		}
	 */	
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC PROPERTIES
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicProps:int;
		
		public function get rendererData ():CarouselRendererData { return data_p; }
		public function set rendererData (value:CarouselRendererData):void
		{
		//	log('set rendererData', value);
			data_p = value;
			populateTitle();
		}
		
	/* 	public function get title ():String { return title_p.text; }
		public function set title (value:String):void
		{
			title_p.text = value;
		}
		
		public function get source ():Bitmap { return source_p; }
		public function set source (value:Bitmap):void
		{
			source_p = value;
			populateImage();
		}
	 */	
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicMethods:int;
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________protectedMethods:int;
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			var border:int = 30;
			var wid:Number = getExplicitOrMeasuredWidth();
			var hei:Number = getExplicitOrMeasuredHeight();
			var halfWid:Number = wid / 2;
			var halfHei:Number = hei / 2;
		//	var halfWidWithBorder:Number = halfWid - border;
		//	var widWithBorder:Number = halfWidWithBorder * 2;
			
		//	log('createChildren', halfWid, hei, parent, alpha, scaleX, scaleY);
			
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(-halfWid, -halfWid, width, border);
			graphics.endFill();
			
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(-halfWid, -halfWid + border, border, wid - (border * 2));
			graphics.endFill();
			
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(halfWid - border, -halfWid + border, border, wid - (border * 2));
			graphics.endFill();
			
			graphics.beginFill(0xDDDDDD);
			graphics.drawRect(-halfWid, halfWid - border, wid, (hei - wid) + border);
			graphics.endFill();
			
			graphics.lineStyle(1, 0x666666);
			graphics.moveTo( -halfWid, -halfWid );
			graphics.lineTo( halfWid, -halfWid );
			graphics.lineTo( halfWid, halfWid + (hei - wid) );
			graphics.lineTo( -halfWid, halfWid + (hei - wid) );
			graphics.lineTo( -halfWid, -halfWid );
			
		//	graphics.beginFill(0xFFFFFF);
		//	graphics.drawRect(-halfWidWithBorder, -halfWidWithBorder, widWithBorder, widWithBorder);
		//	graphics.endFill();
			
			graphics.lineStyle(1, 0xCCCCCC);
			graphics.moveTo( -halfWid + border, -halfWid + border );
			graphics.lineTo( -halfWid + border, halfWid - border );
			graphics.lineTo( halfWid - border, halfWid - border );
			graphics.lineTo( halfWid - border, -halfWid + border );
			graphics.lineTo( -halfWid + border, -halfWid + border );
			
		/* 	
			image_p = new Image();
			image_p.width = widWithBorder;
			image_p.height = widWithBorder;
			populateImage();
		*/	
			
			title_p = new Text();
		//	title_p.text = 'LABEL WILL GO HERE';
			title_p.width = wid - (border * 2);
			title_p.height = 40;
			title_p.x = -halfWid + border;
			title_p.y = halfWid - border;
			title_p.setStyle('textAlign', 'center');
			populateTitle();
			
		//	addChild(image_p);
			addChild(title_p);
		}
		
		override protected function measure ():void
		{
			width = 210;
			height = 250;
		}
		
	/* 	protected function populateImage ():void
		{
			if (source_p is Bitmap && image_p is Image){
				source_p.smoothing = true;
				image_p.source = source_p;
			}
		}
	 */	
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE PROPERTIES
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateProps:int;
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateMethods:int;
		
		private function populateTitle ():void
		{
			if ( !(title_p is Text) ) return;
			title_p.text = 'null';
			if (data_p is CarouselRendererData && data_p.label is Object) title_p.text = data_p.label.toString();
		}

		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// LISTENERS
		// ------------------------------------------------------------------------------------------------------------------------------		
		private var ____________________listenerMethods:int;
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// UTILITY
		// ------------------------------------------------------------------------------------------------------------------------------		
		private var ____________________utility:int;
		
		private function log (...rest):void
		{
			rest.unshift(NAMESPACE);
			Logger.log(rest);
		}
	}
}