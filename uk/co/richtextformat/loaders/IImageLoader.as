package uk.co.richtextformat.loaders
{
	import flash.display.Loader;
	
	public interface IImageLoader extends IAbstractLoader
	{
		function getImageFile (fileName:String, andDelete:Boolean = true):Loader;
		
		function addImageFileName (fileName:String, priority:String = null):Boolean;
		function addImageFileNames (fileNames:Array, priority:String = null):Boolean;
	}
}