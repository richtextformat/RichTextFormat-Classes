package uk.co.richtextformat.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	import uk.co.richtextformat.events.DataEvent;
	import uk.co.richtextformat.events.LoaderEvent;
	import uk.co.richtextformat.logs.Logger;

	public class ImageLoader extends AbstractLoader implements IImageLoader
	{
		private var loader:Loader;
				
		private static const PREFIX:String = 'ImageLoader::';
		
		public static const HIGH_PRIORITY:String = PREFIX + ABSTRACT_HIGH_PRIORITY;
		public static const LOW_PRIORITY:String = PREFIX + ABSTRACT_LOW_PRIORITY;
		
		public static const DORMANT:String = PREFIX + ABSTRACT_DORMANT;
		public static const LOADING:String = PREFIX + ABSTRACT_LOADING;
	//	public static const LOADING_ONE:String = PREFIX + ABSTRACT_LOADING_ONE;
	//	public static const LOADING_ALL:String = PREFIX + ABSTRACT_LOADING_ALL;
		
		public function ImageLoader (target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		override protected function init ():void
		{
			_state = DORMANT;
			super.init();
		}
		
		
		
		
		
		public function getImageFile (fileName:String, andDelete:Boolean = true):Loader
		{
			if ( !hasFile(fileName) ) return null;
			
			var loader:Loader = Loader( files[fileName] );
			if (andDelete) removeFile(fileName);
			return loader;
		}
		
		
		
		
		
		public function addImageFileName (fileName:String, priority:String = null):Boolean
		{
			priority = priority == HIGH_PRIORITY ? ABSTRACT_HIGH_PRIORITY : priority;
			return super.addFileName(fileName, priority);
		}
		
		public function addImageFileNames (fileNamesToAdd:Array, priority:String = null):Boolean
		{
			priority = priority == HIGH_PRIORITY ? ABSTRACT_HIGH_PRIORITY : priority;
			return super.addFileNames(fileNamesToAdd, priority);
		}
		
		
		
		
		
		override protected function createLoader ():void
		{
			if (loader){
				if ( loader.contentLoaderInfo.hasEventListener(Event.COMPLETE) ){
					loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
				}
				if ( loader.contentLoaderInfo.hasEventListener(ProgressEvent.PROGRESS) ){
					loader.contentLoaderInfo.removeEventListener(ProgressEvent.PROGRESS, onLoadProgress);
				}
				if ( loader.contentLoaderInfo.hasEventListener(IOErrorEvent.IO_ERROR) ){
					loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				}
			}
			
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		override protected function loadFile ():void
		{
		//	log('loadFile', _state, fileNameLoading, fileNames.length)
			if (_state == LOADING) return;
			_state = LOADING;
		//	log('loadFile RUNNING...');
			
			super.loadFile();
			var loaderContext:LoaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
			loader.load( new URLRequest(fileNameLoading), loaderContext );
		}
		
		
		
		
		
		override protected function onLoadComplete (event:Event):void
		{
			_state = DORMANT;
			
			files[fileNameLoading] = loader;
			
			super.onLoadComplete(event);
		}
		
		override protected function onLoadError (event:IOErrorEvent):void
		{
		//	log('onLoadError');
			_state = DORMANT;
			super.onLoadError(event);
		//	dispatchEvent( new DataEvent(LoaderEvent.IMAGE_LOAD_ERROR, fileNameLoading) );
		}
		
		
		
		
		
		private function log (...rest):void
		{
			rest.unshift(PREFIX);
			Logger.log(rest);
		}
	}
}