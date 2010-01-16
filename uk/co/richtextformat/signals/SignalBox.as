package uk.co.richtextformat.signals
{
	import flash.utils.Dictionary;
	
	import org.osflash.signals.Signal;
	
	public class SignalBox implements ISignalBox
	{
		private var signals:Dictionary;
		
		public function SignalBox ()
		{
			init();
		}
		
		private function init ():void
		{
			signals = new Dictionary();
		}
		
		
		
		// ------------------------------------------------------
		// PUBLIC
		// ------------------------------------------------------
		private var _________________________public:int;
				
		public function addListener (signalName:String, listener:Function, valueClass:Class = null):void
		{
			var signal:Signal = getSignal(signalName, valueClass);
			signal.add(listener);
		}
		
		public function addListenerOnce (signalName:String, listener:Function, valueClass:Class = null):void
		{
			var signal:Signal = getSignal(signalName, valueClass);
			signal.addOnce(listener)
		}
		
		public function deleteSignal (signalName:String):void
		{
			if ( !hasSignal(signalName) ) return;
			
			var signal:Signal = getSignal(signalName);
			signal.removeAll();
			delete signals[signalName];
		}
		
		public function dispatchSignal (signalName:String, valueObject:Object = null, andDeleteIfLastListener:Boolean = true):void
		{
			if ( !hasSignal(signalName) ) 
				throw new Error('SignalBox dispatchSignal ERROR: "' + signalName + '" is a non-existent signal, and is therefore dispatching it is pointless as nothing is listening for it.');
			
			var signal:Signal = getSignal(signalName);
			valueObject == null ? signal.dispatch() : signal.dispatch(valueObject);
				
			if (andDeleteIfLastListener && !signal.numListeners) deleteSignal(signalName);
		}
		
		public function hasSignal (signalName:String):Boolean
		{
			return signals[signalName] is Signal;
		}
		
		public function removeAllListeners (signalName:String, andDelete:Boolean = true):void
		{
			if ( !hasSignal(signalName) ) return;
			
			var signal:Signal = getSignal(signalName);
			andDelete ? deleteSignal(signalName) : signal.removeAll();
		}
		
		public function removeListener (signalName:String, listener:Function, andDeleteIfLastListener:Boolean = true):void
		{
			if ( !hasSignal(signalName) ) return;
			
			var signal:Signal = getSignal(signalName);
			signal.remove(listener);
			if (andDeleteIfLastListener && !signal.numListeners) deleteSignal(signalName);
		}
		
		
		
		// ------------------------------------------------------
		// PRIVATE
		// ------------------------------------------------------
		private var _________________________private:int;
				
		private function getSignal (signalName:String, valueClass:Class = null):Signal
		{
			var signal:Signal;
			
			if ( signals[signalName] is Signal ){
				signal =  Signal( signals[signalName] );
			//	trace('SignalBox EXISTING Signal', signalName, signal.valueClasses);
				
			} else {
			//	if (valueClass == null) valueClass = String;
				signal = valueClass is Class ? new Signal(valueClass) : new Signal();
				signals[signalName] = signal;
			//	trace('SignalBox NEW Signal', signalName, signal.valueClasses);
			}
			
			return signal;
		}
	}
}