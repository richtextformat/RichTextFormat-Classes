package uk.co.richtextformat.events
{
	import flash.events.Event;

	public class LoaderEvent extends Event
	{
		private var _fileName:String;
		
		private static const PREFIX:String = 'LoaderEvent::';
		
		public static const XML_FILE_LOADED:String = PREFIX + 'XMLFileLoaded';
		public static const IMAGE_FILE_LOADED:String = PREFIX + 'ImageFileLoaded';
		
		public static const XML_LOAD_ERROR:String = PREFIX + 'XMLLoadError';
		public static const IMAGE_LOAD_ERROR:String = PREFIX + 'ImageLoadError';
		
		public static const ALL_XML_FILES_LOADED:String = PREFIX + 'AllXMLFilesLoaded';
		public static const ALL_IMAGE_FILES_LOADED:String = PREFIX + 'AllImageFilesLoaded';
		
		public static const ALL_FILES_LOADED:String = PREFIX + 'AllFilesLoaded';
		
		public function LoaderEvent (type:String, fileName:String = null, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			_fileName = fileName;
		}
		
		public function get fileName ():String { return _fileName; }
		
		override public function clone ():Event
		{
			return new LoaderEvent(type, _fileName, bubbles, cancelable);
		}
	}
}