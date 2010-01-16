package uk.co.richtextformat.flex.view.components.carousel
{
	public class CarouselRendererData
	{
		internal var _index:int;
		internal var _label:Object;
		internal var _source:Object;
		internal var _smoothing:Boolean;
		
		private static const NAMESPACE:String = 'CarouselRendererData::';
		
		private static const DEFAULT_VALUE:String = NAMESPACE + 'DefaultValue_' + int( Math.random() * 1000000 );
		
		public function CarouselRendererData (key:String)
		{
			init(key);
		}
		
		private function init (key:String):void
		{
			if (key != Carousel.KEY) throw new Error('CarouselRenderer init ERROR: only the Carousel class can instantiate a CarouselRenderer instance.');
			_label = DEFAULT_VALUE;
			_source = DEFAULT_VALUE;
			_smoothing = false;
		}
		
		public function get index ():int { return _index; }
		public function get label ():Object { return _label; }
		public function get source ():Object { return _source; }
		public function get smoothing ():Boolean { return _smoothing; }
	}
}