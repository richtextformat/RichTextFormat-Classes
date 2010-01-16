package uk.co.richtextformat.loaders
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.ProgressEvent;
	
	import uk.co.richtextformat.events.LoaderEvent;
	import uk.co.richtextformat.logs.Logger;

	public class FileLoader extends EventDispatcher implements IFileLoader
	{
		private var fileTypeLoading:String;
		private var _numberOfFilesToLoad:int;
		
		private var _state:String;
		
		private var loadOrder:Array;

		private var currentLoader:IAbstractLoader;
		private var imageLoader:ImageLoader;
		private var xmlLoader:XMLLoader;
		
		private static const PREFIX:String = 'FileLoader::';
		
		public static const HIGH_PRIORITY:String = PREFIX + 'HighPriority';
		public static const LOW_PRIORITY:String = PREFIX + 'LowPriority';
		
		public static const DORMANT:String = PREFIX + 'Dormant';
		public static const LOADING:String = PREFIX + 'Loading';
		public static const POST_LOAD:String = PREFIX + 'PostLoad';
		public static const LOAD_ERROR:String = PREFIX + 'LoadError';
		
	//	public static const IMAGE_LOAD_ERROR:String = PREFIX + 'ImageLoadError';
	//	public static const XML_LOAD_ERROR:String = PREFIX + 'XMLLoadError';
		
		private static const IMAGE_NEXT:String = 'ImageNext';
		private static const XML_NEXT:String = 'XMLNext';
		
		public function FileLoader (target:IEventDispatcher=null)
		{
			super(target);
			init();
		}
		
		private function init ():void
		{
			loadOrder = [];
			_numberOfFilesToLoad = 0;
			_state = DORMANT;
		}
		
		private function createImageLoader ():void
		{
			if (imageLoader is ImageLoader) return;
			
			imageLoader = new ImageLoader();
			imageLoader.addEventListener(LoaderEvent.IMAGE_FILE_LOADED, onFileLoaded);
			imageLoader.addEventListener(ProgressEvent.PROGRESS, onFerryEvent);
			imageLoader.addEventListener(LoaderEvent.IMAGE_LOAD_ERROR, onLoadError);
		//	imageLoader.addEventListener(LoaderEvent.ALL_FILES_LOADED, allFilesLoaded);
		}
		
		private function createXMLLoader ():void
		{
			if (xmlLoader is XMLLoader) return;
			
			xmlLoader = new XMLLoader();
			xmlLoader.addEventListener(LoaderEvent.XML_FILE_LOADED, onFileLoaded);
			xmlLoader.addEventListener(ProgressEvent.PROGRESS, onFerryEvent);
	//		xmlLoader.addEventListener(LoaderEvent.XML_LOAD_ERROR, onLoadError);
		//	xmlLoader.addEventListener(LoaderEvent.ALL_FILES_LOADED, allFilesLoaded);
		}
		
		
		
		
		
		public function get fileNameCurrentlyLoading ():String
		{
			return currentLoader is IAbstractLoader ? currentLoader.fileNameCurrentlyLoading : null;
		}
		
		public function get numberOfFilesToLoad ():int
		{
			return imageLoader.numberOfFilesToLoad + xmlLoader.numberOfFilesToLoad;
		}
		
		public function get state ():String
		{
			return _state;
		}
		
		public function getImageFile (fileName:String, andDelete:Boolean=true):Loader
		{
			return imageLoader.getImageFile(fileName, andDelete);
		}
		
		public function getXMLFile (fileName:String, andDelete:Boolean=true):XML
		{
			return xmlLoader.getXMLFile(fileName, andDelete);
		}
		
		
		
		
		
		public function addFileName (fileName:String, priority:String=null):Boolean
		{
			var fileType:String = fileName.substring( fileName.lastIndexOf('.') + 1, fileName.length ).toLowerCase();
			var success:Boolean;
			var fileTypeToLoad:String;
			
			switch (fileType)
			{
				case 'xml':
					createXMLLoader();
					success = xmlLoader.addXMLFileName(fileName, priority);
					fileTypeToLoad = XML_NEXT;
					break;
				
				default:
					createImageLoader();
					success = imageLoader.addImageFileName(fileName, priority);
					fileTypeToLoad = IMAGE_NEXT;
					break;
			}
			
			if (success) priority == HIGH_PRIORITY ? loadOrder.unshift(fileTypeToLoad) : loadOrder.push(fileTypeToLoad);
			
		//	log('addFileName', fileName, loadOrder.length, loadOrder );
			return success;
		}
		
		public function addFileNames (fileNamesToAdd:Array, priority:String=null):Boolean
		{
			var fileName:String;
			var i:int;
			var len:int = fileNamesToAdd.length;
			var success:Boolean = true;
			
			if (priority == HIGH_PRIORITY){
				for (i=len; i>0; i--) if ( !addFileName( fileNamesToAdd[i].toString(), priority ) ) success = false;
				
			} else {
				for (i=0; i<len; i++) if ( !addFileName( fileNamesToAdd[i].toString(), priority ) ) success = false;
			}
			
		//	log('addFileNames', fileNamesToAdd, loadOrder, loadOrder );
			return success;
		}
		
		
		
		
		
		public function hasFile (fileName:String):Boolean
		{
			if ( xmlLoader is XMLLoader && xmlLoader.hasFile(fileName) ) return true;
			return imageLoader is ImageLoader ? imageLoader.hasFile(fileName) : false;
		}
		
		public function hasFileName (fileName:String):Boolean
		{
			if ( xmlLoader is XMLLoader && xmlLoader.hasFileName(fileName) ) return true;
			return imageLoader is ImageLoader ? imageLoader.hasFileName(fileName) : false;
		}
		
		public function hasFileNamesToLoad ():Boolean
		{
			return xmlLoader.hasFileNamesToLoad() || imageLoader.hasFileNamesToLoad() ? true : false;
		}
		
		
		
		
		
		public function loadNextFile ():void
		{
			var amountOfFilesCurrentlyLoading:int = fileTypeLoading == null ? 0 : 1;
			if ( _numberOfFilesToLoad < (amountOfFilesCurrentlyLoading + loadOrder.length) ) ++_numberOfFilesToLoad;
		//	log('loadNextFile', fileTypeLoading, loadOrder.length, _numberOfFilesToLoad );
			loadFile();
		}
		
		public function loadAllFiles ():void
		{
			var amountOfFilesCurrentlyLoading:int = fileTypeLoading == null ? 0 : 1;
			_numberOfFilesToLoad = amountOfFilesCurrentlyLoading + loadOrder.length;
		//	log('loadAllFiles', fileTypeLoading, loadOrder.length, _numberOfFilesToLoad );
			loadFile();
		}
		
		
		
		
		
		private function analysePostLoad (event:LoaderEvent):void
		{
			--_numberOfFilesToLoad;
			fileTypeLoading = null;
			var formerLoader:IAbstractLoader = currentLoader;
			currentLoader = null;
			
		//	log('analysePostLoad onFileLoaded', event.fileName, formerLoader);
			dispatchEvent(event);
			
			switch (formerLoader)
			{
				case xmlLoader:
					if ( !xmlLoader.hasFileNamesToLoad() ) dispatchEvent( new Event(LoaderEvent.ALL_XML_FILES_LOADED) );
					break;
				
				case imageLoader:
					if ( !imageLoader.hasFileNamesToLoad() ) dispatchEvent( new Event(LoaderEvent.ALL_IMAGE_FILES_LOADED) );
					break;
			}
			
		//	log('analysePostLoad', loadOrder.length, _numberOfFilesToLoad, _state);
			switch (true)
			{
				case !loadOrder.length:				dispatchEvent( new Event(LoaderEvent.ALL_FILES_LOADED) );			break;
				case _numberOfFilesToLoad > 0:		loadFile();															break;
				default:							_state = DORMANT;													break;
			}
		}
		
		private function loadFile ():void
		{
		//	log('FileLoader loadFile STATE', _state);
			if (_state == LOADING) return;
			_state = LOADING;
			fileTypeLoading = loadOrder.shift().toString();
		//	log('FileLoader loadFile', _numberOfFilesToLoad, fileTypeLoading, '///' ,loadOrder);
			
			switch (fileTypeLoading)
			{
				case XML_NEXT:
					createXMLLoader();
					currentLoader = xmlLoader;
					break;
				
				case IMAGE_NEXT:
					createImageLoader();
					currentLoader = imageLoader;
					break;
			}
			
			currentLoader.loadNextFile();
		}
		
		private function onFileLoaded (event:LoaderEvent):void
		{
		//	log('onFileLoaded', event.fileName);
			_state = POST_LOAD;
			analysePostLoad(event);
		}
		
		private function onLoadError (event:LoaderEvent):void
		{
		//	log('onLoadError', event.fileName);
			_state = LOAD_ERROR;
			analysePostLoad(event);
		}
		
		private function onFerryEvent (event:Event):void
		{
			dispatchEvent(event);
		}
		
		
		
		
		
		private function log (...rest):void
		{
			rest.unshift(PREFIX);
			Logger.log(rest);
		}
	}
}