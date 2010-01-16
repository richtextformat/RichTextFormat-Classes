package uk.co.richtextformat.math
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import uk.co.richtextformat.events.DataEvent;
	import uk.co.richtextformat.logs.Logger;
	
	public class SoftNumberTweener extends EventDispatcher
	{
		private var acceleration_p:Number;
		private var easingDegree_p:Number;
		
		private var currentIndex_p:Number;
		private var targetIndex_p:Number;
		private var formerTargetIndex_p:Number;
		private var currentValue_p:Number;
		private var maxTween_p:Number;
		
		private var state:String;
		private var eventFirer:Sprite;
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// CONSTANTS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________constants:int;
		
		private static const NAMESPACE:String = 'SoftNumberTweener::';
		
		public static const STARTING:String = NAMESPACE + 'Starting';
		public static const UPDATE:String = NAMESPACE + 'Update';
		public static const COMPLETE:String = NAMESPACE + 'Complete';
	
		private static const DORMANT:String = NAMESPACE + 'Dormant';
		private static const ACCELERATING:String = NAMESPACE + 'Accelerating';
		private static const IN_MOTION:String = NAMESPACE + 'InMotion';
		private static const DECELERATING:String = NAMESPACE + 'Decelerating';
		
		private static const ACCELERATION_DEGREE:Number = 0.0125;
		private static const MAX_ACCELERATION:Number = 1.0;
		private static const PROXIMITY_DEGREE:Number = 0.009;
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// INIT METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________initMethods:int;
		
		public function SoftNumberTweener ():void
		{
			super();
			init();
		}
		
		private function init ():void
		{
			state = DORMANT;
			
			acceleration_p = 0.0;
			easingDegree_p = 0.3;
			
			currentValue_p = 0.0;
			currentIndex_p = 0.0;
			targetIndex_p = 0.0;
			maxTween_p = 0.4;
			
		//	reset();
		}
		
		public function reset ():void
		{
			
		}
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC PROPERTIES
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicProps:int;
		
		public function get currentIndex ():Number { return currentIndex_p; }
		public function set currentIndex (value:Number):void
		{
			if ( eventFirer is Sprite && eventFirer.hasEventListener(Event.ENTER_FRAME) ){
				eventFirer.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			}
		//	log('set currentIndex', eventFirer)
			currentValue_p = currentIndex_p = targetIndex_p = value;
			acceleration_p = 0.0;
			state = DORMANT;
		}
		
		public function get currentValue ():Number { return currentValue_p; }
	//	public function set currentValue (value:Number):void
	//	{
	//		currentValue_p = value;
	//	}
		
		public function get easingDegree ():Number { return easingDegree_p; }
		public function set easingDegree (value:Number):void
		{
			if ( value <= 0 || value >= 1 ) throw new Error('SoftNumberTweener set easingDegree ERROR: easingDegree mus be between 0 and 1. Passed value is :' + value);
			easingDegree_p = value;
		}
		
		public function get maxTween ():Number { return maxTween_p; }
		public function set maxTween (value:Number):void
		{
			if ( value <= 0.1 || value > 1 ) throw new Error('SoftNumberTweener set maxTween ERROR: maxTween mus be between 0.09 and 1. Passed value is :' + value);
			maxTween_p = value;
		}
		
		public function get targetIndex ():Number { return targetIndex_p; }
		public function set targetIndex (value:Number):void
		{
			if (value == targetIndex_p) return;
			
			switch (true)
			{
				case state == DORMANT:			state = ACCELERATING;											break;
				case state == DECELERATING:		if ( reverseAcceleration(value) ) state = ACCELERATING;			break;
				case state == ACCELERATING:
					if ( reverseAcceleration(value) ){
						formerTargetIndex_p = targetIndex_p;
						state = DECELERATING;
					}
					break;
			}
			
			targetIndex_p = value;
		//	log('set targetIndex', targetIndex_p, state, hasEventListener(Event.ENTER_FRAME));
			
			if ( !(eventFirer is Sprite) ) eventFirer = new Sprite();
			if ( !eventFirer.hasEventListener(Event.ENTER_FRAME) ) eventFirer.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PUBLIC METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________publicMethods:int;
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PROTECTED METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________protectedMethods:int;
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE PROPERTIES
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateProps:int;
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// PRIVATE METHODS
		// ------------------------------------------------------------------------------------------------------------------------------
		private var ____________________privateMethods:int;
		
		private function adjustAcceleration ():void
		{
			switch (state)
			{
				case ACCELERATING:
					acceleration_p += ACCELERATION_DEGREE;
					if (acceleration_p >= MAX_ACCELERATION){
						acceleration_p = MAX_ACCELERATION;
						state = IN_MOTION;
					}
					break;
				
				case DECELERATING:
					acceleration_p -= (ACCELERATION_DEGREE * 3);
					if (acceleration_p <= 0){
						acceleration_p = 0;
						state = ACCELERATING;
					}
					break;
			}
		}
		
		private function reverseAcceleration (value:Number):Boolean
		{
			return ( ( targetIndex_p > currentValue_p && value < currentValue_p ) || ( targetIndex_p < currentValue_p && value > currentValue_p ) );
		}
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// LISTENERS
		// ------------------------------------------------------------------------------------------------------------------------------		
		private var ____________________listenerMethods:int;
		
		private function onEnterFrame (event:Event):void
		{
			adjustAcceleration();
			
			var actualTarget:Number = state == DECELERATING ? formerTargetIndex_p : targetIndex_p;
			var increment:Number = ( ( actualTarget - currentValue_p ) * easingDegree_p );
			if (increment > maxTween_p) increment = maxTween_p;
			if (increment < -maxTween_p) increment = -maxTween_p;
			increment *= acceleration_p;
		//	log('onEnterFrame incr:',increment);
			
			currentValue_p += increment;
			dispatchEvent( new DataEvent(UPDATE, currentValue_p) );
			
			var targetGap:Number = targetIndex_p - currentValue_p;
			if (targetGap < 0) targetGap *= -1;
		//	log('onEnterFrame vals:', currentIndex_p, targetIndex_p, currentValue_p, increment, currentValue_p, easingDegree_p, targetGap);
			
			if (targetGap < PROXIMITY_DEGREE){
				currentIndex = targetIndex_p;
				dispatchEvent( new DataEvent(COMPLETE, currentValue_p) );
			}
		}
		
		
		
		
		
		
		// ------------------------------------------------------------------------------------------------------------------------------
		// UTILITY
		// ------------------------------------------------------------------------------------------------------------------------------		
		private var ____________________utility:int;
		
		private function log (...rest):void
		{
			rest.unshift(NAMESPACE);
			Logger.log(rest);
		}
	}
}