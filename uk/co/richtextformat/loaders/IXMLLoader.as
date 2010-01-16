package uk.co.richtextformat.loaders
{
	public interface IXMLLoader extends IAbstractLoader
	{
		function getXMLFile (fileName:String, andDelete:Boolean = true):XML;
		
		function addXMLFileName (fileName:String, priority:String = null):Boolean;
		function addXMLFileNames (fileNames:Array, priority:String = null):Boolean;
	}
}