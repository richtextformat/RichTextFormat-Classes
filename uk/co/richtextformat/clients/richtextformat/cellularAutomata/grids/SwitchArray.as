package uk.co.richtextformat.clients.richtextformat.cellularAutomata.grids
{
	import flash.events.EventDispatcher;
	
	import uk.co.richtextformat.clients.richtextformat.cellularAutomata.events.SwitchEvent;
	import uk.co.richtextformat.math.Random;
	
	public class SwitchArray extends EventDispatcher
	{
		public var switches:Array;
				
		
		
		
		
		// -------------------------------------------------------------
		// construct
		
		public function SwitchArray()
		{
			_init();
		}
		
		private function _init ():void
		{
			_createSwitches();
		}
		
		private function _createSwitches ():void
		{
			// our eight basic rules (switches)
			switches = new Array(2);
			switches[0] = new Array(2);
			switches[1] = new Array(2);
			switches[0][0] = new Array(2);
			switches[0][1] = new Array(2);
			switches[1][0] = new Array(2);
			switches[1][1] = new Array(2);
			
			switches[0][0][0] = 1;
			switches[0][0][1] = 1;
			switches[0][1][0] = 1;
			switches[0][1][1] = 1;
			switches[1][0][0] = 1;
			switches[1][0][1] = 1;
			switches[1][1][0] = 1;
			switches[1][1][1] = 1;
		}
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// public
		
		public function randomiseSwitches ():void
		{
			var len:int = switches.length * 2;
			for (var i:int=0; i<len; i++){
				_toggleSwitch();
			}
		}
		
		public function tryToggleSwitch ():void
		{
			if (Random.generate(0,32)>31){
				_toggleSwitch();
			}
		}
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// private
		
		private function _toggleSwitch ():void
		{
			//re.port("Cellular Automata _simulate: "x+" : " +y+" : " +z);
			
			// get a switch at a random point
			var ri:String = Random.INTEGER;
			var x:int = Random.generate(0,1,ri);
			var y:int = Random.generate(0,1,ri);
			var z:int = Random.generate(0,1,ri);
			var s:int = switches[x][y][z] as int;
			
			// toggle it
			s = s? 0:1;
			switches[x][y][z] = s;
			
			dispatchEvent( new SwitchEvent(SwitchEvent.TOGGLED, s, x, y, z) );
		}
		
		
		
		
		
		
		
		
		// -------------------------------------------------------------
		// debug
		
		private function _traceSwitches ():void
		{
			trace("Switch_000", switches[0][0][0]); 
			trace("Switch_001", switches[0][0][1]); 
			trace("Switch_010", switches[0][1][0]); 
			trace("Switch_011", switches[0][1][1]); 
			trace("Switch_100", switches[1][0][0]); 
			trace("Switch_101", switches[1][0][1]); 
			trace("Switch_110", switches[1][1][0]); 
			trace("Switch_111", switches[1][1][1]); 
		}
	}
}