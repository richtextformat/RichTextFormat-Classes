package uk.co.richtextformat.signals
{
	public interface ISignalBox
	{
		function addListener (signalName:String, listener:Function, valueClass:Class = null):void;
		function addListenerOnce (signalName:String, listener:Function, valueClass:Class = null):void;
		function deleteSignal (signalName:String):void;
		function dispatchSignal (signalName:String, valueObject:Object = null, andDeleteIfLastListener:Boolean = true):void;
		function hasSignal (signalName:String):Boolean;
		function removeAllListeners (signalName:String, andDelete:Boolean = true):void;
		function removeListener (signalName:String, listener:Function, andDeleteIfLastListener:Boolean = true):void;
	}
}