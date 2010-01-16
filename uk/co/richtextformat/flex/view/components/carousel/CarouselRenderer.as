package uk.co.richtextformat.flex.view.components.carousel
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.events.ProgressEvent;
	
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.controls.Text;
	import mx.controls.listClasses.BaseListData;
	import mx.core.UIComponent;
	
	import uk.co.richtextformat.events.DataEvent;
	import uk.co.richtextformat.logs.Logger;
	
	public class CarouselRenderer extends UIComponent implements ICarouselRenderer
	{
		protected var image:Image;
		protected var label:Text;
	//	protected var border:Sprite;
		
		protected var data_p:CarouselRendererData;
		protected var listData_p:BaseListData;
		
		private static const NAMESPACE:String = 'CarouselRenderer::';
		
		[Embed(systemFont="Tahoma", fontName="embeddedTahoma", mimeType="application/x-font")]
		protected var labelFont:Class;

		public function CarouselRenderer ()
		{
			super();
			init();
		}
		
		private function init ():void
		{
			addEventListener(MouseEvent.CLICK, onClick);
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
		
		
		
		public function get data ():Object { return data_p; }
		
		public function set data (value:Object):void
		{
			data_p = CarouselRendererData(value);
		//	log('set data', this.name, data_p, data_p.label, data_p.source);
			populateLabel();
		}
		
		public function get listData ():BaseListData { return listData_p; }
		public function set listData (value:BaseListData):void { listData_p = value; }
		
		
		
		
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			var wid:Number = getExplicitOrMeasuredWidth();
			var hei:Number = getExplicitOrMeasuredHeight();
		//	log('createChildren', this.name, data_p, data_p is CarouselRendererData, data_p.label, data_p.source);
			
			/* border = new Sprite();
			border.graphics.lineStyle(1, 0xC0FFEE);
			border.graphics.moveTo( -halfWid, -halfHei );
			border.graphics.lineTo( halfWid, -halfHei );
			border.graphics.lineTo( halfWid, halfHei );
			border.graphics.lineTo( -halfWid, halfHei );
			border.graphics.lineTo( -halfWid, -halfHei );
			addChild(border); */
			
			label = new Text();
			label.width = wid;
			label.height = hei - wid;
			label.setStyle('fontFamily', 'embeddedTahoma');
			label.setStyle('textAlign', 'center');
			label.selectable = false;
			populateLabel();
			addChild(label);
			
			image = new Image();
			image.width = wid;
			image.height = wid;
			image.addEventListener(ProgressEvent.PROGRESS, onImageLoadProgress);
			image.addEventListener(Event.COMPLETE, onImageLoadComplete);
			image.addEventListener(IOErrorEvent.IO_ERROR, onImageLoadError);
			addChild(image);
			
			setSource();
		}
		
		override protected function commitProperties ():void
		{
			super.commitProperties();
			invalidateDisplayList();
		}
		
		protected function getNullImage ():Bitmap
		{
			var wid:Number = getExplicitOrMeasuredWidth();
		//	var hei:Number = getExplicitOrMeasuredHeight();
			
			var nullLabel:Label = new Label();
			nullLabel.width = wid;
			nullLabel.height = wid;
			nullLabel.setStyle('fontFamily', 'embeddedTahoma');
			nullLabel.setStyle('textAlign', 'center');
			nullLabel.setStyle('paddingTop', (wid-20) / 2 );
			nullLabel.text = 'Image Not Available';
			addChild(nullLabel);
			nullLabel.validateNow();
		//	log('getNullImage', nullLabel.stage);
			
			var nullData:BitmapData = new BitmapData(wid, wid, false, 0xc0ffee);
			nullData.draw(nullLabel);
			
			removeChild(nullLabel);
			
			var nullImage:Bitmap = new Bitmap(nullData);
			nullImage.smoothing = data_p.smoothing;
			return nullImage;
		}
		
		override protected function measure ():void
		{
			width = getExplicitOrMeasuredWidth();
			height = getExplicitOrMeasuredHeight();
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
		//	log('updateDisplayList');
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			
			var halfWid:Number = getExplicitOrMeasuredWidth() / 2;
			var halfHei:Number = getExplicitOrMeasuredHeight() / 2;
			
			image.move( -halfWid, -halfHei );
			label.move( -halfWid, image.y + image.getExplicitOrMeasuredHeight() );
		}
		
		
		
		
		
	/* 	private function initialised ():Boolean
		{
			return label is Label && image 
		}
	 */	
		protected function populateLabel ():void
		{
			if ( !(label is Text) || !(data_p is CarouselRendererData) ) return;
		//	log('populateLabel',data_p.label is Object, data_p.label);
			label.text = data_p.label is Object ? data_p.label.toString() : 'null';
		}
		
		private function setBitmap ():void
		{
			if (data_p.source is Bitmap){
				image.source = data_p.source;
				image.source.smoothing = data_p.smoothing;
				
			} else {
				image.source = getNullImage();
			}
		}
		
		private function setSource ():void
		{
			if ( !(image is Image) || !(data_p is CarouselRendererData) ) return;
			
			switch (true)
			{
				case data_p.source is String:			image.source = data_p.source.toString();			break;
				case data_p.source is Bitmap:
				case data_p.source == null:				setBitmap();										break;
				default:
					throw new Error('CarouselRenderer set data ERROR: dataRenderer property "source" must be either a String ' + 
						'(a valid URL to an loadable image source) or a Bitmap.');
					break;
			}
			
		}
		
		
		
		
		
		protected function onAddedToStage (event:Event):void
		{
			setSource();
			commitProperties();
			invalidateProperties();
		}
		
		protected function onClick (event:MouseEvent):void
		{
		//	log('onClick', data_p.index);
			dispatchEvent( new DataEvent(Carousel.RENDERER_CLICK, data_p.index) );
		}
		
		protected function onImageLoadProgress (event:ProgressEvent):void
		{
		//	log('onImageLoadProgress', event.bytesLoaded);
		}
		
		protected function onImageLoadComplete (event:Event):void
		{
		//	log('onImageLoadComplete', image.content, data_p.smoothing);
			Bitmap(image.content).smoothing = data_p.smoothing;
			
		}
		
		protected function onImageLoadError (event:IOErrorEvent):void
		{
		//	log('onImageLoadError', event.text);
			image.source = getNullImage();
		}
		
		
		
		
		
		private function log (...rest):void
		{
			rest.unshift(NAMESPACE);
			Logger.log(rest);
		}
	}
}	