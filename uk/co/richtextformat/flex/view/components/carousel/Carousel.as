package uk.co.richtextformat.flex.view.components.carousel
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import mx.binding.utils.BindingUtils;
	import mx.containers.Canvas;
	import mx.controls.HSlider;
	import mx.core.ClassFactory;
	import mx.core.IFactory;
	import mx.core.UIComponent;
	import mx.events.SliderEvent;
	import mx.styles.CSSStyleDeclaration;
	import mx.styles.StyleManager;
	
	import uk.co.richtextformat.events.DataEvent;
	import uk.co.richtextformat.logs.Logger;
	import uk.co.richtextformat.math.SoftNumberTweener;
	
	[Style(name="carouselColor", type="int", format="Length", inherit="yes")]
	[Style(name="carouselPaddingTop", type="Number", format="Length", inherit="yes")]
	
	public class Carousel extends Canvas
	{
		// view
		protected var container_p:Canvas;
		protected var slider_p:HSlider;
		protected var sliderTween:SoftNumberTweener;
		protected var itemRenderer_p:ClassFactory;
		protected var currentRenderer_p:ICarouselRenderer;
		protected var focusFrame_p:CarouselFocusFrame;
		
		// model
		protected var dataProvider_p:Object;
		protected var parsedDataProvider_p:Array;
		protected var renderers_p:Array;
		protected var renderersPool_p:Array;
		protected var renderersData_p:Array;
		protected var renderersDataPool_p:Array;
		
		// indices
		protected var selectedIndex_p:int;
		protected var labelField_p:String;
		protected var sourceField_p:Object;
		
		// renderer props
		protected var rendererHeight_p:int;
		protected var rendererWidth_p:int;
		protected var halfHypotenuse_p:Number;
		protected var smoothing_p:Boolean;
		protected var focusFrameAlphaIncrement_p:Number;
		protected var focusFrameDisplaysConstantly_p:Boolean;
		
		// layout props
		protected var diameter_p:int;
		protected var radius_p:Number;
		protected var rendererGap_p:uint;
		protected var centrePoint_p:Point;
		protected var arcPerRenderer_p:Number;
		protected var sliderIntervalGap_p:int;
		protected var paddingTop_p:int;
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// CONSTANTS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________constants:int;
		
		private static const NAMESPACE:String = 'Carousel::';
		
		public static const RENDERER_CLICK:String = NAMESPACE + 'RendererClick';
		
		public static const MIN_DIAMETER:int = 1024;
		public static const MAX_DIAMETER:int = 8192;
		
		internal static const KEY:String = NAMESPACE + 'Key_' + int( Math.random() * 1000000 );
		
		protected static const PI:Number = Math.PI;
		protected static const TWO_PI:Number = PI * 2;
		protected static const RADIANS_TO_DEGREES_MULTIPLIER:Number = 180 / TWO_PI;
		protected static const FOCUS_FRAME_ALPHA_INCREMENT:Number = 0.2;
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// INIT METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________initMethods:int;
		
		public function Carousel ()
		{
			super();
			init();
		}
		
		private function init ():void
		{
			
			horizontalScrollPolicy = 'off';
			verticalScrollPolicy = 'off';
			
			labelField_p = 'label';
			sourceField_p = 'source';
			
			parsedDataProvider_p = [];
			renderers_p = [];
			renderersPool_p = [];
			renderersData_p = [];
			renderersDataPool_p = [];
			
			rendererHeight_p = 190;
			rendererWidth_p = 150;
			setHalfHypotenuse();
			smoothing_p = true;
			focusFrameAlphaIncrement_p = FOCUS_FRAME_ALPHA_INCREMENT;
			focusFrameDisplaysConstantly_p = true;
			paddingTop_p = 0;
			
			sliderIntervalGap_p = 50;
			
			centrePoint_p = new Point(0, 0);
			rendererGap_p = 50;
			diameter_p = MAX_DIAMETER / 2;
			radius_p = diameter_p / 2;
		}
		
		protected function createFocusFrame ():void
		{
			if ( !(focusFrame_p is CarouselFocusFrame) ) focusFrame_p = new CarouselFocusFrame();
		}
		
		private function createItemRendererFactory (value:IFactory = null):void
		{
			if (!value) value = new ClassFactory();
			itemRenderer_p = ClassFactory(value);
			
			switch (true)
			{
				case !itemRenderer_p.generator:
					itemRenderer_p.generator = CarouselRenderer;
					break;
				
				case !(itemRenderer_p.generator is ICarouselRenderer):
					throw new Error('Carousel set itemRenderer ERROR: passed class"' + itemRenderer_p + '" does not implement interface ICarouselRenderer, which it must.');
					break;
			}
		}
		
		private function createRenderers ():void
		{
			var len:int = parsedDataProvider_p.length;
			if (renderers_p.length == len) return;
			if ( !(itemRenderer_p is ClassFactory) ) createItemRendererFactory();
		//	log('createRenderers START');
			
			var renderer:UIComponent;
			var rendererData:CarouselRendererData;
			var rendererClass:Class = itemRenderer_p.generator;
			
			switch (true)
			{
				case renderers_p.length < len:
					for (var i:int=renderers_p.length; i<len; i++){
						
						if (renderersPool_p[0] is rendererClass){
							renderer = rendererClass( renderersPool_p.shift() );
							
						} else {
							renderer = itemRenderer_p.newInstance();
							renderer.width = rendererWidth_p;
							renderer.height = rendererHeight_p;
							renderer.addEventListener(RENDERER_CLICK, onRendererClick);
							renderer.useHandCursor = 
								renderer.buttonMode = 
								true;
						}
						
						renderers_p.push(renderer);
						
						rendererData = renderersDataPool_p[0] is CarouselRendererData ?
							CarouselRendererData( renderersDataPool_p.shift() ) : 
							new CarouselRendererData(KEY);
						renderersData_p.push(rendererData);
					}
					break;
				
				case renderers_p.length > len:
					var excessRenderers:Array = renderers_p.splice(len, renderers_p.length - len);
					var excessRendererData:Array = renderersData_p.splice(len, renderersData_p.length - len);
					renderersPool_p = renderersPool_p.concat(excessRenderers);
					renderersDataPool_p = renderersDataPool_p.concat(excessRendererData);
					break;
			}
		//	log('createRenderers array lens:', parsedDataProvider_p.length, renderers_p.length, renderersPool_p.length);
		}
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC PROPERTIES
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicProps:int;
		
		public function get container ():Canvas { return container_p; }
		
		public function get dataProvider ():Object { return dataProvider_p; }
		public function set dataProvider (value:Object):void
		{
		//	log('___________________________ set dataProvider ___________________________');
		//	if (dataProvider_p == value) return;
			
			removeRenderers();
			dataProvider_p = value;
			parsedDataProvider_p = [];
			
			switch (true)
			{
				case value is Array:			parseArray(dataProvider_p as Array);				break;
				default:
					throw new Error('Carousel set dataProvider ERROR: Carousel dataProvider only accepts arrays at present.');
					break;
			}
			
			slider_p.visible = parsedDataProvider_p.length ? true : false;
			
			if (parsedDataProvider_p.length){
			//	log('set dataProvider', dataProvider_p);
				slider_p.maximum = parsedDataProvider_p.length - 0.51;
				resizeSlider();
				commitProperties();
				selectedIndex = int( (parsedDataProvider_p.length / 2) - 0.25 );
			}
		}
		
		public function get diameter ():int { return diameter_p; }
		public function set diameter (value:int):void
		{
			if (value < MIN_DIAMETER || value > MAX_DIAMETER){
				throw new Error('Carousel set diameter ERROR: passed diameter of "' + value + 
					'" is either less than the permitted MIN_DIAMETER of "' + MIN_DIAMETER + 
					'" or greater than the permitted MAX_DIAMETER of "' + MAX_DIAMETER + '".');
			}
			
			if (diameter_p == value) return;
			
			diameter_p = value;
			radius_p = diameter_p / 2;
			calculateMetrics();
		}
		
		public function get focusFrame ():CarouselFocusFrame { return focusFrame_p; }
		public function set focusFrame (value:CarouselFocusFrame):void
		{
			if ( !(value is CarouselFocusFrame) ) throw new Error('Carousel set focusFrame ERROR: focusFrame must be an instance of CarouselFocusFrame.');
			setFocusFrame(value);
		}
		
		public function get focusFrameDisplaysConstantly ():Boolean { return focusFrameDisplaysConstantly_p; }
		public function set focusFrameDisplaysConstantly (value:Boolean):void
		{
			focusFrameDisplaysConstantly_p = value;
		}
		
		public function get itemRenderer ():IFactory { return itemRenderer_p; }
		public function set itemRenderer (value:IFactory):void
		{
			if (itemRenderer_p == value) return;
			createItemRendererFactory(value);
			if ( purgeRenderers() ) commitProperties();
		}
		
		public function get labelField ():String { return labelField_p; }
		public function set labelField (value:String):void
		{
			if (labelField_p == value) return;
			labelField_p = value;
			commitProperties();
		}	
		
		public function get rendererGap ():uint { return rendererGap_p; }
		public function set rendererGap (value:uint):void
		{
		//	if (value > (getExplicitOrMeasuredWidth() / 2) ){
		//		throw new Error('Carousel set rendererGap ERROR: passed gap of "' + value + '" is greater than the available component width allows.' + getExplicitOrMeasuredWidth());
		//	}
			
			if (rendererGap_p == value) return;
			rendererGap_p = value;
		}
		
		public function get rendererHeight ():int { return rendererHeight_p; }
		public function set rendererHeight (value:int):void
		{
			rendererHeight_p = value;
		}
		
		public function get rendererWidth ():int { return rendererWidth_p; }
		public function set rendererWidth (value:int):void
		{
			rendererWidth_p = value;
		}
		
		public function get selectedIndex ():int { return selectedIndex_p; }
		public function set selectedIndex (value:int):void
		{
			if (value < 0 || value > parsedDataProvider_p.length){
				throw new Error('Carousel set selectedIndex ERROR: passed index of "' + value + '" is out of bounds.');
			}
			
			if (selectedIndex_p == value) return;
			selectedIndex_p = value;
		//	log('set selectedIndex', selectedIndex_p)
			sliderTween.currentIndex = selectedIndex_p;
			slider.value = selectedIndex_p;
			
			disableCurrentRenderer();
			addFocusFrame(true);
			
			invalidateProperties();
		}
		
		public function get selectedItem ():Object
		{
		//	log('get selectedItem', selectedIndex_p, renderersData_p.length, renderersData_p[selectedIndex_p] );
			return parsedDataProvider_p[selectedIndex_p];
		}
		
		public function set selectedItem (value:Object):void
		{
			setSelectedItem(value);
		}
		
		public function get slider ():HSlider { return slider_p; }
		
		public function get sliderIntervalGap ():int { return sliderIntervalGap_p; }
		public function set sliderIntervalGap (value:int):void
		{
			if (sliderIntervalGap_p == value) return;
			sliderIntervalGap_p = value;
		}
		
		public function get smoothing ():Boolean { return smoothing_p; }
		public function set smoothing (value:Boolean):void
		{
			smoothing_p = value;
		}
		
		public function get sourceField ():Object { return sourceField_p; }
		public function set sourceField (value:Object):void
		{
			if (sourceField_p == value) return;
			sourceField_p = value;
			commitProperties();
		}
		
		public function get targetIndex ():int { return int(sliderTween.targetIndex); }
		public function set targetIndex (value:int):void
		{
			if (value < 0 || value > parsedDataProvider_p.length){
				throw new Error('Carousel set selectedIndex ERROR: passed index of "' + value + '" is out of bounds.');
			}
			
			if (selectedIndex_p == value) return;
			selectedIndex_p = value;
			enablePreviousRenderer();
			sliderTween.targetIndex = selectedIndex_p;
		}
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicMethods:int;
		
		override public function setStyle (styleProp:String, newValue:*):void
		{
		 	log('setStyle', styleProp, newValue );
			
			switch ( styleProp.toLowerCase() )
			{
				case 'carouselcolor':
					container_p.setStyle('backgroundColor', int(newValue));
					break;
				
				case 'carouselpaddingtop':
					paddingTop_p = Number(newValue);
					break;
				
				default:
					super.setStyle(styleProp, newValue);
					break;
			}
		}
		
	/* 	override public function styleChanged (styleProp:String):void
		{
			log('styleChanged', styleProp);
			super.styleChanged(styleProp);
		} */
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________protectedMethods:int;
		
		override protected function createChildren ():void
		{
			super.createChildren();
			
			slider_p = new HSlider();
			slider_p.visible = false;
			slider_p.minimum = -0.5;
			slider_p.addEventListener(SliderEvent.CHANGE, onSliderChange);
			slider_p.addEventListener(SliderEvent.THUMB_DRAG, onSliderDrag);
			slider_p.addEventListener(SliderEvent.THUMB_RELEASE, onSliderRelease);
		//	slider_p.snapInterval = 1;
			
			sliderTween = new SoftNumberTweener();
			sliderTween.addEventListener(SoftNumberTweener.UPDATE, onSliderTweenUpdate);
			sliderTween.addEventListener(SoftNumberTweener.COMPLETE, onSliderTweenComplete);
			
			container_p = new Canvas();
			container_p.horizontalScrollPolicy = 'off';
			container_p.verticalScrollPolicy = 'off';
			
			BindingUtils.bindProperty(container_p, 'width', this, 'width');
			BindingUtils.bindProperty(slider_p, 'width', this, 'width');
		//	BindingUtils.bindProperty(container_p, 'height', slider_p, 'y');
			
			addChild(container_p);
			addChild(slider_p);
			
			initializeStyle('carouselColor');
		}
		
		override protected function commitProperties ():void
		{
			super.commitProperties();
			populateRenderers();
		}
		
		override protected function updateDisplayList (unscaledWidth:Number, unscaledHeight:Number):void
		{
			super.updateDisplayList(unscaledWidth, unscaledHeight);
			update();
		}
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE PROPS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateProps:int;
		
		private function setFocusFrame (value:CarouselFocusFrame):void
		{
			var formerFrame:* = focusFrame_p;
			focusFrame_p = value;
			positionFocusFrame();
			
		//	log('setFocusFrame', formerFrame, focusFrame_p);
			
			if ( formerFrame is CarouselFocusFrame && contains(formerFrame) ){
				value.alpha = formerFrame.alpha;
				removeChild(formerFrame);
				addChild(focusFrame_p);
			}
		}
		
		private function setHalfHypotenuse ():void
		{
			halfHypotenuse_p = Math.sqrt( (rendererWidth_p * rendererWidth_p) + (rendererHeight_p * rendererHeight_p) ) / 2;
		}
		
		private function setSelectedItem (value:Object):void
		{
			var len:int = parsedDataProvider_p.length;
			
			for (var i:int=0; i<len; i++){
				if ( parsedDataProvider_p[i] == value ){
					selectedIndex = i;
					break;
				}
			}
		}
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateMethods:int;
		
		private function addFocusFrame (addDirectly:Boolean):void
		{
			positionFocusFrame();
			populateFocusFrame();
			
		//	log('addFocusFrame', addDirectly, focusFrameDisplaysConstantly_p);
			
			if (addDirectly || focusFrameDisplaysConstantly_p){
				if ( hasEventListener(Event.ENTER_FRAME) ) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				focusFrame_p.alpha = 1;
				
			} else {
			//	log('addFocusFrame ADD ENTER_FRAME');
				if ( !hasEventListener(Event.ENTER_FRAME) ) addEventListener(Event.ENTER_FRAME, onEnterFrame);
				focusFrame_p.alpha = 0;
				focusFrameAlphaIncrement_p = FOCUS_FRAME_ALPHA_INCREMENT;
			}
			
			var index:int = contains(focusFrame_p) ? numChildren - 1 : numChildren;
			addChildAt(focusFrame_p, index);
		}
		
		private function calculateMetrics ():void
		{
			centrePoint_p.x = container_p.getExplicitOrMeasuredWidth() / 2;
			centrePoint_p.y = (container_p.getExplicitOrMeasuredHeight() / 2) + radius_p;
		//	log('calculateMetrics', centrePoint_p.x, centrePoint_p.y);
			
			var circumference:Number = diameter_p * Math.PI;
			var spacePerRenderer:int = rendererWidth_p + rendererGap_p;
			arcPerRenderer_p = (spacePerRenderer / circumference) * TWO_PI;
		//	var amountOfRenderers:int = renderers_p.length;
		//	var spaceRequiredForRenderers:int = spacePerRenderer * renderers_p.length;
		}
		
		private function disableCurrentRenderer ():void
		{
			enablePreviousRenderer();
			
			currentRenderer_p = ICarouselRenderer( renderers_p[selectedIndex_p] );
			currentRenderer_p.removeEventListener(RENDERER_CLICK, onRendererClick);
			
			if (currentRenderer_p is Sprite){
				var rendererAsSprite:Sprite = Sprite(currentRenderer_p);
				
				rendererAsSprite.useHandCursor = 
					rendererAsSprite.buttonMode = 
					false;
			}
		}
		
		private function enablePreviousRenderer ():void
		{
			if (currentRenderer_p is ICarouselRenderer && !currentRenderer_p.hasEventListener(Event.ENTER_FRAME) ){
				currentRenderer_p.addEventListener(RENDERER_CLICK, onRendererClick);
				
				if (currentRenderer_p is Sprite){
					var rendererAsSprite:Sprite = Sprite(currentRenderer_p);
					rendererAsSprite.useHandCursor = 
						rendererAsSprite.buttonMode = 
						true;
				}
			}
		}
		
		private function initializeStyle (styleProp:String):void
		{
			var style:* = getStyle(styleProp);
			if (style != null) setStyle(styleProp, style);
		}
		
		private function parseArray (source:Array):void
		{
			parsedDataProvider_p = source.slice();
		//	log('parseArray', parsedDataProvider_p);
		}
		
		private function populateFocusFrame ():void
		{
		//	log('populateFocusFrame', selectedItem);
			focusFrame_p.rendererData = CarouselRendererData( renderersData_p[selectedIndex_p] );
		}
		
		private function populateRenderers ():void
		{
			var rendererDataHasChanged:Boolean = renderers_p.length ? true : false;
			createRenderers();
			createFocusFrame();
			
			var obj:Object;
			var renderer:ICarouselRenderer;
			var rendererData:CarouselRendererData;
			var rendererLabel:Object;
			var rendererSource:Object;
			var renderersHaveChanged:Boolean = false;
			var len:int = parsedDataProvider_p.length;
			
		//	log('populateRenderers', len);
			
			for (var i:int=0; i<len; i++){
				obj = parsedDataProvider_p[i];
				rendererData = CarouselRendererData( renderersData_p[i] );
				rendererData._index = i;
				rendererDataHasChanged = false;
				
				if (rendererData.smoothing != smoothing_p){
					rendererData._smoothing = smoothing_p;
					rendererDataHasChanged = true;
				}
				
			//	log('populateRenderers rendererData:', i, rendererData.label, rendererData.source );
			//	log('populateRenderers name:', labelField_p, obj[labelField_p] );
				if ( labelField_p is String && obj[labelField_p] is Object ) rendererLabel = Object( obj[labelField_p] );
				if (rendererLabel != rendererData.label){
					rendererData._label = rendererLabel;
					rendererDataHasChanged = true;
				}
				
				if (sourceField_p is String){
					switch (true)
					{
						case obj[sourceField_p] is Bitmap:
							rendererData._source = Bitmap( obj[sourceField_p] );
							rendererDataHasChanged = true;
							break;
						
						case obj[sourceField_p] is String:
							rendererData._source = obj[sourceField_p].toString();
							rendererDataHasChanged = true;
							break;
						
						case obj[sourceField_p] == null && rendererData.source != null:
							rendererData._source = null;
							rendererDataHasChanged = true;
					}
				}
				
				if (rendererDataHasChanged){
				//	log('populateRenderers rendererDataHasChanged!', i, rendererData.label, rendererData.source );
					renderersHaveChanged = true;
					renderer = itemRenderer_p.generator( renderers_p[i] );
					renderer.data = rendererData;
				}
			}
			
			if (renderersHaveChanged){
			//	log('populateRenderers renderersHaveChanged! invalidateDisplayList!');
				invalidateDisplayList();
			}
		//	log('populateRenderers array lens:', parsedDataProvider_p.length, renderers_p.length, renderersPool_p.length);
		}
		
		private function positionFocusFrame ():void
		{
			if (focusFrame_p is CarouselFocusFrame){
				focusFrame_p.move(
					centrePoint_p.x,
					centrePoint_p.y - radius_p - ( (rendererHeight_p - rendererWidth_p) / 2) + paddingTop_p
				);
			}
		//	log('positionFocusFrame', focusFrame_p.x, focusFrame_p.y);
		}
		
		private function positionRenderer (renderer:UIComponent, index:int):void
		{
			var adjustment:Number = sliderTween.currentValue - index;
		//	log('positionRenderer', sliderTween.currentValue, adjustment);
			var pointOnCircumference:Number = PI + (adjustment * arcPerRenderer_p);
			
			renderer.x = centrePoint_p.x + ( Math.sin(pointOnCircumference) * radius_p );
			renderer.y = centrePoint_p.y + ( Math.cos(pointOnCircumference) * radius_p );
			renderer.rotation = ( ( ( ( TWO_PI - pointOnCircumference ) * RADIANS_TO_DEGREES_MULTIPLIER ) + 90 ) % 180 ) * 2;
			
		//	log('positionRenderer', centrePoint_p.x, centrePoint_p.y, adjustment, arcPerRenderer_p, selectedIndex_p, index, pointOnCircumference;
		//	log('positionRenderer', renderer.x, renderer.y);//, renderer.rotation);
		}
		
		private function purgeRenderers ():Boolean
		{
		//	log('purgeRenderers array lens:', renderers_p.length, renderersPool_p.length);
			renderersPool_p = renderersPool_p.concat( renderers_p.splice(0, renderers_p.length) );
		//	log('purgeRenderers array lens:', renderers_p.length, renderersPool_p.length);
			var renderer:*;
			var rendererClass:Class = itemRenderer_p.generator;
			var renderersHaveBeenPurged:Boolean = false;
			
			for (var i:int=0; i<renderersPool_p.length; i++){
				renderer = renderersPool_p[i];
				
				if ( !(renderer is rendererClass) ){
					renderersHaveBeenPurged = true;
					renderersPool_p.splice(--i, 1);
					if ( container_p.contains(renderer) ) removeChild(renderer);
				}
			//	log('purgeRenderers I:', i, renderersPool_p.length);
			}
		//	log('purgeRenderers array lens:', renderers_p.length, renderersPool_p.length);
		return renderersHaveBeenPurged;
		}
		
		private function removeFocusFrame (removeDirectly:Boolean):void
		{
		//	log('removeFocusFrame');
			focusFrame_p.rendererData = null;
			if (focusFrameDisplaysConstantly_p) return;
			
			if (removeDirectly){
				if ( contains(focusFrame_p) ) removeChild(focusFrame_p);
				if ( hasEventListener(Event.ENTER_FRAME) ) removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
			} else {
				focusFrameAlphaIncrement_p = -FOCUS_FRAME_ALPHA_INCREMENT;
				if ( !hasEventListener(Event.ENTER_FRAME) ) addEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		}
		
		private function removeRenderers ():void
		{
		//	log('removeRenderers');
			removeFocusFrame(true);
			
			var len:int = container_p.numChildren;
			for (var i:int=0; i<len; i++) container_p.removeChild( container_p.getChildAt(0) );
		}
		
		private function resizeSlider ():void
		{
			var wid:int = container_p.getExplicitOrMeasuredWidth();
			slider_p.width = parsedDataProvider_p.length * sliderIntervalGap_p < wid ? parsedDataProvider_p.length * sliderIntervalGap_p : wid;
		//	log('resizeSlider', wid, parsedDataProvider_p.length, sliderIntervalGap_p, slider.width, slider.x);
		}
		
		private function toggleRendererAttachment (renderer:UIComponent):void
		{
			var shouldAttach:Boolean = true;
			var containerWidth:int = container_p.getExplicitOrMeasuredWidth();
			var containerHeight:int = container_p.getExplicitOrMeasuredHeight();
			
			switch (true)
			{
				case renderer.y - halfHypotenuse_p > containerHeight:
				case renderer.x + halfHypotenuse_p < 0:
				case renderer.x - halfHypotenuse_p > containerWidth:				shouldAttach = false;				break;
			}
			
		//	log('toggleRendererAttachment', renderer.x + halfHypotenuse_p, containerWidth, shouldAttach );
		//	log('toggleRendererAttachment', renderer.x - halfHypotenuse_p, shouldAttach );
		//	log('toggleRendererAttachment', renderer.y - halfHypotenuse_p,  shouldAttach );
		//	log('toggleRendererAttachment', shouldAttach, renderer.x, renderer.y, halfHypotenuse_p, 
		//		container_p.getExplicitOrMeasuredHeight(), container_p.getExplicitOrMeasuredWidth() );
			
			if (shouldAttach){
				if ( !( container_p.contains(renderer) ) ) container_p.addChild(renderer);
				
			} else {
				if ( container_p.contains(renderer) ) container_p.removeChild(renderer);
			}
		}
		
		private function update ():void
		{
		//	log('update -----------------------------------------------------------------');
			
			container_p.move(0, paddingTop_p);
			
			resizeSlider();
			slider_p.move( (width - slider_p.width) / 2, height - slider_p.getExplicitOrMeasuredHeight() );
			container_p.height = slider_p.y - 20;
			
			calculateMetrics();

			var renderer:UIComponent;
			var len:int = renderers_p.length;
			
			for (var i:int=0; i<len; i++){
				renderer = UIComponent( renderers_p[i] );
				positionRenderer(renderer, i);
				toggleRendererAttachment(renderer);
			}
			container_p.height -= slider_p.height;
			
			positionFocusFrame();
		//		container_p.addChildAt(focusFrame_p, container_p.numChildren) : 
		//		container_p.setChildIndex(focusFrame_p, container_p.numChildren - 1);
			
		//	log('update', focusFrame_p.parent, focusFrame_p.alpha, focusFrame_p.x, focusFrame_p.y, focusFrame_p.width);
		//	log('update', container_p.width, container_p.height, container_p.x, container_p.y, container_p.visible, container_p.alpha, container_p.parent);
		}
			
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// LISTENERS
		// ------------------------------------------------------------------------------------------------------------------------------		
		private var ____________________listenerMethods:int;
		
		private function onEnterFrame (event:Event):void
		{
			focusFrame_p.alpha += focusFrameAlphaIncrement_p;
			
		//	log('onEnterFrame', focusFrame_p.alpha);
			switch (true)
			{
				case focusFrame_p.alpha >= 1:
					focusFrame_p.alpha = 1;
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
				
				case focusFrame_p.alpha <= 0:
					if ( contains(focusFrame_p) ) removeChild(focusFrame_p);
				//	log('onEnterFrame');
					focusFrame_p.alpha = 0;
					removeEventListener(Event.ENTER_FRAME, onEnterFrame);
					break;
			}
		}
		
		private function onRendererClick (event:DataEvent):void
		{
			log('onRendererClick', event.data);
			removeFocusFrame(false);
			
			var value:int = int(event.data);
			targetIndex = value;
			slider_p.value = value;
		}
		
		private function onSliderChange (event:SliderEvent):void
		{
		//	log('onSliderChange');
			var value:int = Math.round(event.value);
			
			if (value != selectedIndex_p){
				removeFocusFrame(false);
				targetIndex = value;
				slider_p.value = value;
			}
		}
		
		private function onSliderDrag (event:SliderEvent):void
		{
			onSliderChange(event);
			slider_p.value = event.value;
		}
		
		private function onSliderRelease (event:SliderEvent):void
		{
			slider_p.value = selectedIndex_p;
		}
		
		private function onSliderTweenUpdate (event:DataEvent):void
		{
		//	log('onSliderTweenUpdate', event.data);
			update();
		}
		
		private function onSliderTweenComplete (event:DataEvent):void
		{
		//	log('onSliderTweenComplete', event.data);
			disableCurrentRenderer();
			addFocusFrame(false);
		}
		
		
		
		
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