package uk.co.richtextformat.loaders
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.utils.Dictionary;
	
	import uk.co.richtextformat.events.LoaderEvent;
	import uk.co.richtextformat.logs.Logger;

	public class AbstractLoader extends EventDispatcher implements IAbstractLoader
	{
		protected var files:Dictionary;
		protected var fileNames:Array;
		protected var fileNameLoading:String;
		protected var fileNamesLoaded:Array;
		protected var _numberOfFilesToLoad:int;
		
		protected var _state:String;
		
		private static const NAMESPACE:String = 'AbstractLoader::';
		
		protected static const ABSTRACT_HIGH_PRIORITY:String = 'HighPriority';
		protected static const ABSTRACT_LOW_PRIORITY:String = 'LowPriority';
		
		protected static const ABSTRACT_DORMANT:String = 'Dormant';
		protected static const ABSTRACT_LOADING:String = 'Loading';
	//	protected static const ABSTRACT_LOADING_ONE:String = 'LoadingOne';
	//	protected static const ABSTRACT_LOADING_ALL:String = 'LoadingAll';
		
		public function AbstractLoader (target:IEventDispatcher=null)
		{
			super(target);
			if ( !(this is XMLLoader) && !(this is ImageLoader) )
				throw new Error('AbstractLoader ERROR: You cannot instantiate this class directly.');
		}
		
		protected function init ():void
		{
			fileNames = [];
			fileNamesLoaded = [];
			files = new Dictionary();
		}
		
		
		
		
		
		public function get fileNameCurrentlyLoading ():String
		{
			return fileNameLoading;
		}
		
		public function get numberOfFilesToLoad ():int
		{
			return _numberOfFilesToLoad;
		}
		
		public function get state ():String
		{
			return _state;
		}
		
		
		
		
		
		public function loadNextFile ():void
		{
		//	log('loadNextFile');
			if ( _numberOfFilesToLoad < fileNames.length ) ++_numberOfFilesToLoad;
			loadFile();
		}
		
		public function loadAllFiles ():void
		{
			_numberOfFilesToLoad = fileNames.length;
			loadFile();
		}
		
		public function hasFile (fileName:String):Boolean
		{
			return files[fileName] != null;
		}
		
		public function hasFileName (fileName:String):Boolean
		{
			return fileNames.indexOf(fileName) > -1;
		}
		
		public function hasFileNamesToLoad ():Boolean
		{
			return fileNames.length > 0;
		}
		
		
		
		
		
		protected function addFileName (fileName:String, priority:String = null):Boolean
		{
			if ( fileNameExists(fileName) ) return false;
			
			switch (priority)
			{
				case ABSTRACT_HIGH_PRIORITY:		fileNames.unshift(fileName);							break;
				default:							fileNames.push(fileName);								break;
			}
		//	trace('AbstractLoader addFileName', fileNames);
			return true;
		}
		
		protected function addFileNames (fileNamesToAdd:Array, priority:String = null):Boolean
		{
			var fileName:String;
			var i:int;
			var len:int = fileNamesToAdd.length;
			var success:Boolean = true;
			
			if (priority == ABSTRACT_HIGH_PRIORITY){
				for (i=len; i>0; i--) if ( !addFileName( fileNamesToAdd[i].toString(), priority ) ) success = false;
				
			} else {
				for (i=0; i<len; i++) if ( !addFileName( fileNamesToAdd[i].toString(), priority ) ) success = false;
			}
			
			return success;
		}
		
		protected function createLoader ():void {}
		
		protected function loadFile ():void
		{
			if ( !fileNames.length ) throw new Error('AbstractLoader loadFile ERROR: the loader currently has no filenames, so cannot load anything');
			createLoader();
			fileNameLoading = fileNames.shift().toString();
		}
		
		protected function fileNameExists (fileNameToCheck:String):Boolean
		{
			var extantFileName:String;
			if (fileNameToCheck == fileNameLoading) return true;
			for each (extantFileName in fileNames) if (fileNameToCheck == extantFileName) return true;
			for each (extantFileName in fileNamesLoaded) if (fileNameToCheck == extantFileName) return true;
			return false;
		}
		
		protected function removeFile (fileName:String):void
		{
			delete files[fileName];
			
			var len:int = fileNamesLoaded.length;
			for (var i:int=0; i<len; i++){
				if ( fileNamesLoaded[i].toString().toLowerCase() == fileName.toLowerCase() ){
					fileNamesLoaded.splice(i, 1);
					break;
				}
			}
		}
		
		
		
		
		
		protected function onLoadProgress (event:ProgressEvent):void
		{
		//	trace('onLoadProgress', event.bytesLoaded, event.bytesTotal);
			dispatchEvent(event);
		}
		
		protected function onLoadComplete (event:Event):void
		{
			--_numberOfFilesToLoad;
			
			var loadedFileName:String = fileNameLoading;
			fileNamesLoaded.push(loadedFileName);
			fileNameLoading = null;
			
			var eventName:String;
			switch (true)
			{
				case this is XMLLoader:				eventName = LoaderEvent.XML_FILE_LOADED;				break;
				case this is ImageLoader:			eventName = LoaderEvent.IMAGE_FILE_LOADED;				break;
			}
			dispatchEvent( new LoaderEvent(eventName, loadedFileName) );
			
			assessPostLoadState(loadedFileName);
		//	trace('AbstoractLoader onLoadComplete', fileNames.length, fileNameLoading)
		}
		
		protected function onLoadError (event:IOErrorEvent):void
		{
			--_numberOfFilesToLoad;
			
			var loadedFileName:String = fileNameLoading;
		//	fileNamesLoaded.push(loadedFileName);
			fileNameLoading = null;
			
			var eventName:String;
			switch (true)
			{
				case this is XMLLoader:				eventName = LoaderEvent.XML_LOAD_ERROR;					break;
				case this is ImageLoader:			eventName = LoaderEvent.IMAGE_LOAD_ERROR;				break;
			}
			dispatchEvent( new LoaderEvent(eventName, loadedFileName) );
			
			assessPostLoadState(loadedFileName);
		}
		
		private function assessPostLoadState (loadedFileName:String):void
		{
			if (!fileNames.length && !fileNameLoading){
				_numberOfFilesToLoad = 0;
				
				var eventName:String;
				switch (true)
				{
					case this is XMLLoader:			eventName = LoaderEvent.ALL_XML_FILES_LOADED;			break;
					case this is ImageLoader:		eventName = LoaderEvent.ALL_IMAGE_FILES_LOADED;			break;
				}
				dispatchEvent( new LoaderEvent(eventName) );
			}
			
			if (_numberOfFilesToLoad) loadFile();
		}
		
		
		
		
		
		private function log (...rest):void
		{
			rest.unshift(NAMESPACE);
			Logger.log(rest);
		}
	}
}