package uk.co.richtextformat.loaders
{
	public interface IAbstractLoader
	{
		function get fileNameCurrentlyLoading ():String;
		function get numberOfFilesToLoad ():int;
		function get state ():String;
		
		function hasFile (fileName:String):Boolean;
		function hasFileName (fileName:String):Boolean;
		function hasFileNamesToLoad ():Boolean;
		
		function loadNextFile ():void;
		function loadAllFiles ():void;
	}
}