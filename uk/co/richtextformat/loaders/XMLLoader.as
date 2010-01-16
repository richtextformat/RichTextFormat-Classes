package uk.co.richtextformat.loaders
{
	import flash.events.Event;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	import uk.co.richtextformat.events.DataEvent;
	import uk.co.richtextformat.events.LoaderEvent;
	import uk.co.richtextformat.logs.Logger;

	public class XMLLoader extends AbstractLoader implements IXMLLoader
	{
		private var loader:URLLoader;
				
		private static const PREFIX:String = 'XMLLoader::';
		
		public static const HIGH_PRIORITY:String = PREFIX + ABSTRACT_HIGH_PRIORITY;
		public static const LOW_PRIORITY:String = PREFIX + ABSTRACT_LOW_PRIORITY;
		
		public static const DORMANT:String = PREFIX + ABSTRACT_DORMANT;
		public static const LOADING:String = PREFIX + ABSTRACT_LOADING;
	//	public static const LOADING_ONE:String = PREFIX + ABSTRACT_LOADING_ONE;
	//	public static const LOADING_ALL:String = PREFIX + ABSTRACT_LOADING_ALL;
		
		public function XMLLoader (target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		override protected function init ():void
		{
			_state = DORMANT;
			super.init();
		}
		
		
		
		
		
		public function getXMLFile (fileName:String, andDelete:Boolean = true):XML
		{
			if ( !hasFile(fileName) ) return null;
			
			var xmlFile:XML = files[fileName] as XML;
			if (andDelete) removeFile(fileName);
			return xmlFile;
		}
		
		
		
		
		
		public function addXMLFileName (fileName:String, priority:String = null):Boolean
		{
			priority = priority == HIGH_PRIORITY ? ABSTRACT_HIGH_PRIORITY : priority;
			return super.addFileName(fileName, priority);
		}
		
		public function addXMLFileNames (fileNamesToAdd:Array, priority:String = null):Boolean
		{
			priority = priority == HIGH_PRIORITY ? ABSTRACT_HIGH_PRIORITY : priority;
			return super.addFileNames(fileNamesToAdd, priority);
		}
		
		
		
		
		
		override protected function createLoader ():void
		{
			if (loader is URLLoader) return;
			
			loader = new URLLoader();
			loader.addEventListener(ProgressEvent.PROGRESS, onLoadProgress);
			loader.addEventListener(Event.COMPLETE, onLoadComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
		}
		
		override protected function loadFile ():void
		{
			if (_state == LOADING) return;
			_state = LOADING;
			
			super.loadFile();
		//	trace('XMLLoader loadFile', fileNameLoading, fileNames.length)
			loader.load( new URLRequest(fileNameLoading) );
		}
		
		
		
		
		
		override protected function onLoadComplete (event:Event):void
		{
			_state = DORMANT;
			
			var xmlFile:XML = new XML(loader.data);
			files[fileNameLoading] = xmlFile;
			loader.data = null;
		//	trace('XMLLoader onLoadComplete', files[fileNameLoading]);
			
			super.onLoadComplete(event);
		}
		
		override protected function onLoadError (event:IOErrorEvent):void
		{
		//	log('onLoadError');
			_state = DORMANT;
			super.onLoadError(event);
		//	dispatchEvent( new DataEvent(LoaderEvent.XML_LOAD_ERROR, fileNameLoading) );
		}
		
		
		
		
		
		private function log (...rest):void
		{
			rest.unshift(PREFIX);
			Logger.log(rest);
		}
	}
}